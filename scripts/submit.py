import jwt, time, requests, sys

KEY_ID = 'WDXGY9WX55'
ISSUER = '2be0734f-943a-4d61-9dc9-5d9045c46fec'
APP_ID = '766405796'
BUILD_NUMBER = sys.argv[1] if len(sys.argv) > 1 else ''

p8 = open('/tmp/asc_key.p8').read()

def make_token():
    return jwt.encode(
        {'iss': ISSUER, 'iat': int(time.time()), 'exp': int(time.time()) + 1200, 'aud': 'appstoreconnect-v1'},
        p8, algorithm='ES256', headers={'kid': KEY_ID}
    )

def headers():
    return {'Authorization': f'Bearer {make_token()}', 'Content-Type': 'application/json'}

def api(method, path, **kwargs):
    r = requests.request(method, f'https://api.appstoreconnect.apple.com/v1{path}',
        headers=headers(), **kwargs)
    return r

if APP_ID == 'PLACEHOLDER':
    print('APP_ID not set yet. Skipping submission.')
    sys.exit(0)

print(f'Waiting for build {BUILD_NUMBER} to be processed...')
build_id = None
for i in range(80):
    r = api('GET', f'/builds?filter[app]={APP_ID}&filter[processingState]=VALID&sort=-uploadedDate&limit=1')
    data = r.json()
    if data.get('data'):
        build_id = data['data'][0]['id']
        bv = data['data'][0]['attributes'].get('version', '?')
        print(f'Build ready: {bv} id={build_id}')
        break
    print(f'  Waiting... ({i+1}/80)')
    time.sleep(30)

if not build_id:
    print('WARNING: Build not found. Check ASC manually.')
    sys.exit(0)

# Set export compliance
api('PATCH', f'/builds/{build_id}',
    json={'data': {'type': 'builds', 'id': build_id, 'attributes': {'usesNonExemptEncryption': False}}})

# Find or create version
version_id = None
version_state = None
r = api('GET', f'/apps/{APP_ID}/appStoreVersions?filter[platform]=IOS&limit=1')
if r.json().get('data'):
    version_id = r.json()['data'][0]['id']
    version_state = r.json()['data'][0]['attributes']['appStoreState']
    print(f'Version: {version_id} state={version_state}')

if version_state in ('WAITING_FOR_REVIEW', 'IN_REVIEW'):
    print(f'Already in review. Done.')
    sys.exit(0)

if not version_id or version_state == 'READY_FOR_SALE':
    r = api('POST', '/appStoreVersions', json={
        'data': {'type': 'appStoreVersions',
                 'attributes': {'platform': 'IOS', 'versionString': '1.0'},
                 'relationships': {'app': {'data': {'type': 'apps', 'id': APP_ID}}}}
    })
    if r.status_code not in (200, 201):
        print(f'Failed to create version: {r.text[:200]}')
        sys.exit(1)
    version_id = r.json()['data']['id']
    print(f'Created version: {version_id}')

# Assign build
api('PATCH', f'/appStoreVersions/{version_id}', json={
    'data': {'type': 'appStoreVersions', 'id': version_id,
             'relationships': {'build': {'data': {'type': 'builds', 'id': build_id}}}}
})

# Cancel blocking submissions
for state in ['UNRESOLVED_ISSUES']:
    r = api('GET', f'/apps/{APP_ID}/reviewSubmissions?filter[state]={state}')
    for sub in r.json().get('data', []):
        sid = sub['id']
        api('PATCH', f'/reviewSubmissions/{sid}',
            json={'data': {'type': 'reviewSubmissions', 'id': sid, 'attributes': {'canceled': True}}})
        print(f'Canceled submission {sid[:8]}')

time.sleep(5)

# Submit
r = api('POST', '/reviewSubmissions', json={
    'data': {'type': 'reviewSubmissions',
             'attributes': {'platform': 'IOS'},
             'relationships': {'app': {'data': {'type': 'apps', 'id': APP_ID}}}}
})
if not r.ok:
    print(f'Create submission failed: {r.status_code} {r.text[:200]}')
    sys.exit(0)
sub_id = r.json()['data']['id']

r = api('POST', '/reviewSubmissionItems', json={
    'data': {'type': 'reviewSubmissionItems',
             'relationships': {
                 'reviewSubmission': {'data': {'type': 'reviewSubmissions', 'id': sub_id}},
                 'appStoreVersion': {'data': {'type': 'appStoreVersions', 'id': version_id}}
             }}
})
if not r.ok:
    print(f'Add item failed: {r.status_code} {r.text[:200]}')
    api('PATCH', f'/reviewSubmissions/{sub_id}',
        json={'data': {'type': 'reviewSubmissions', 'id': sub_id, 'attributes': {'canceled': True}}})
    sys.exit(0)

r = api('PATCH', f'/reviewSubmissions/{sub_id}',
    json={'data': {'type': 'reviewSubmissions', 'id': sub_id, 'attributes': {'submitted': True}}})
if r.ok:
    print(f'SUBMITTED! State: {r.json()["data"]["attributes"]["state"]}')
else:
    print(f'Submit failed: {r.status_code} {r.text[:200]}')
