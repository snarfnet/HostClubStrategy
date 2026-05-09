#!/usr/bin/env python3
"""Set up ASC metadata, upload screenshots, assign build, and submit for review."""

import jwt, time, requests, sys, os, hashlib, json

KEY_ID = 'WDXGY9WX55'
ISSUER = '2be0734f-943a-4d61-9dc9-5d9045c46fec'
APP_ID = '6766405796'
KEY_PATH = os.path.expanduser('~/.appstoreconnect/private_keys/AuthKey_WDXGY9WX55.p8')

p8 = open(KEY_PATH).read()

def make_token():
    return jwt.encode(
        {'iss': ISSUER, 'iat': int(time.time()), 'exp': int(time.time()) + 1200, 'aud': 'appstoreconnect-v1'},
        p8, algorithm='ES256', headers={'kid': KEY_ID}
    )

def headers(content_type='application/json'):
    return {'Authorization': f'Bearer {make_token()}', 'Content-Type': content_type}

def api(method, path, **kwargs):
    r = requests.request(method, f'https://api.appstoreconnect.apple.com/v1{path}',
        headers=headers(), **kwargs)
    return r

# ---- Step 1: Find or create version ----
print('=== Step 1: Find app store version ===')
r = api('GET', f'/apps/{APP_ID}/appStoreVersions?filter[platform]=IOS&limit=1')
data = r.json()
if not data.get('data'):
    print('No version found, creating...')
    r = api('POST', '/appStoreVersions', json={
        'data': {'type': 'appStoreVersions',
                 'attributes': {'platform': 'IOS', 'versionString': '1.0'},
                 'relationships': {'app': {'data': {'type': 'apps', 'id': APP_ID}}}}
    })
    version_id = r.json()['data']['id']
else:
    version_id = data['data'][0]['id']
    version_state = data['data'][0]['attributes']['appStoreState']
    print(f'Version: {version_id} state={version_state}')
    if version_state in ('WAITING_FOR_REVIEW', 'IN_REVIEW'):
        print('Already in review. Done.')
        sys.exit(0)

# ---- Step 2: Set version localization (ja) ----
print('\n=== Step 2: Set localization ===')

description_ja = """ホストクラブで担当に本気で向き合いたい女性のための戦略アプリ。

心理学に基づいた攻略診断で、彼の愛着スタイルを分析。あなたの目標に合わせたオーダーメイドの攻略プランを提案します。

--- 主な機能 ---

[ 攻略診断 ]
彼の愛着スタイル（回避型・不安型・安定型）を選んで、関係性の深さや目標に応じた具体的な攻略戦略を受け取れます。

[ 心理学テクニック ]
返報性の法則、ツァイガルニク効果、ミラーリングなど、恋愛心理学のテクニックをホストクラブの場面に落とし込んで解説。

[ 危険度チェック ]
「この人、大丈夫？」を数値化。痛客リスクを客観的にチェックして、自分を守るための判断材料に。

--- こんな人に ---
- 担当との関係をもっと深めたい
- 心理学を使って賢く立ち回りたい
- 自分が痛客になっていないか確認したい
- ホスクラ初心者で基礎知識を知りたい"""

description_en = """A strategy app for women who want to build a real connection at host clubs.

Analyze his attachment style with psychology-based diagnostics and get a personalized strategy plan tailored to your goals.

--- Key Features ---

[ Strategy Diagnosis ]
Select his attachment style (avoidant, anxious, secure) and receive specific strategies based on your relationship depth and goals.

[ Psychology Techniques ]
Learn techniques like reciprocity, the Zeigarnik effect, and mirroring, explained in the context of host club interactions.

[ Risk Check ]
Quantify "Is this person okay?" Objectively assess problem-customer risk to help protect yourself.

--- For You If ---
- You want to deepen your relationship with your host
- You want to use psychology to navigate smarter
- You want to check if you're being a difficult customer
- You're new to host clubs and want to learn the basics"""

keywords_ja = "ホスト,ホストクラブ,攻略,心理学,恋愛,診断,愛着スタイル,テクニック,危険度,ホスクラ"
keywords_en = "host,club,strategy,psychology,romance,diagnosis,attachment,technique,risk,nightlife"

# Get existing localizations
r = api('GET', f'/appStoreVersions/{version_id}/appStoreVersionLocalizations')
existing_locales = {loc['attributes']['locale']: loc['id'] for loc in r.json().get('data', [])}
print(f'Existing locales: {list(existing_locales.keys())}')

for locale, desc, kw in [('ja', description_ja, keywords_ja), ('en-US', description_en, keywords_en)]:
    loc_data = {
        'description': desc,
        'keywords': kw,
        'marketingUrl': 'https://snarfnet.github.io/',
        'supportUrl': 'https://snarfnet.github.io/'
    }
    if locale in existing_locales:
        loc_id = existing_locales[locale]
        r = api('PATCH', f'/appStoreVersionLocalizations/{loc_id}',
            json={'data': {'type': 'appStoreVersionLocalizations', 'id': loc_id, 'attributes': loc_data}})
        print(f'{locale} updated: {r.status_code}')
    else:
        loc_data['locale'] = locale
        r = api('POST', '/appStoreVersionLocalizations', json={
            'data': {'type': 'appStoreVersionLocalizations', 'attributes': loc_data,
                     'relationships': {'appStoreVersion': {'data': {'type': 'appStoreVersions', 'id': version_id}}}}
        })
        print(f'{locale} created: {r.status_code}')
        if r.status_code in (200, 201):
            existing_locales[locale] = r.json()['data']['id']

# ---- Step 3: Upload screenshots ----
print('\n=== Step 3: Upload screenshots ===')

SCREENSHOT_DIR = 'C:/Users/Windows/HostClubStrategy/asc_screenshots_202605060933'

DISPLAY_TYPES = {
    '65': 'APP_IPHONE_65',
    '67': 'APP_IPHONE_67',
}

for locale in ['ja']:
    loc_id = existing_locales.get(locale)
    if not loc_id:
        print(f'No localization for {locale}, skip screenshots')
        continue

    # Get existing screenshot sets
    r = api('GET', f'/appStoreVersionLocalizations/{loc_id}/appScreenshotSets')
    existing_sets = {s['attributes']['screenshotDisplayType']: s['id'] for s in r.json().get('data', [])}

    for size_key, display_type in DISPLAY_TYPES.items():
        # Find screenshots for this size
        screens = sorted([f for f in os.listdir(SCREENSHOT_DIR) if f.startswith(f'screen_{size_key}_') and f.endswith('.png')])
        if not screens:
            print(f'  No screenshots for {display_type}')
            continue

        # Get or create screenshot set
        if display_type in existing_sets:
            set_id = existing_sets[display_type]
            # Delete existing screenshots
            r = api('GET', f'/appScreenshotSets/{set_id}/appScreenshots')
            for ss in r.json().get('data', []):
                api('DELETE', f'/appScreenshots/{ss["id"]}')
            print(f'  Cleared existing {display_type} screenshots')
        else:
            r = api('POST', '/appScreenshotSets', json={
                'data': {'type': 'appScreenshotSets',
                         'attributes': {'screenshotDisplayType': display_type},
                         'relationships': {'appStoreVersionLocalization': {
                             'data': {'type': 'appStoreVersionLocalizations', 'id': loc_id}}}}
            })
            if r.status_code not in (200, 201):
                print(f'  Failed to create set {display_type}: {r.status_code} {r.text[:200]}')
                continue
            set_id = r.json()['data']['id']

        # Upload each screenshot
        for idx, filename in enumerate(screens):
            filepath = os.path.join(SCREENSHOT_DIR, filename)
            filesize = os.path.getsize(filepath)
            with open(filepath, 'rb') as f:
                file_data = f.read()
            checksum = hashlib.md5(file_data).hexdigest()

            # Reserve upload
            r = api('POST', '/appScreenshots', json={
                'data': {'type': 'appScreenshots',
                         'attributes': {'fileName': filename, 'fileSize': filesize},
                         'relationships': {'appScreenshotSet': {
                             'data': {'type': 'appScreenshotSets', 'id': set_id}}}}
            })
            if r.status_code not in (200, 201):
                print(f'  Reserve failed for {filename}: {r.status_code} {r.text[:200]}')
                continue
            ss_id = r.json()['data']['id']
            upload_ops = r.json()['data']['attributes'].get('uploadOperations', [])

            # Upload parts
            for op in upload_ops:
                upload_url = op['url']
                offset = op['offset']
                length = op['length']
                upload_headers = {h['name']: h['value'] for h in op['requestHeaders']}
                chunk = file_data[offset:offset+length]
                resp = requests.put(upload_url, headers=upload_headers, data=chunk)

            # Commit
            r = api('PATCH', f'/appScreenshots/{ss_id}', json={
                'data': {'type': 'appScreenshots', 'id': ss_id,
                         'attributes': {'uploaded': True, 'sourceFileChecksum': {'type': 'md5', 'value': checksum}}}
            })
            status = r.json().get('data', {}).get('attributes', {}).get('assetDeliveryState', {}).get('state', '?')
            print(f'  {filename}: {status}')

# ---- Step 4: Set app info (category) ----
print('\n=== Step 4: Set category ===')
r = api('GET', f'/apps/{APP_ID}/appInfos')
if r.json().get('data'):
    info_id = r.json()['data'][0]['id']
    r = api('PATCH', f'/appInfos/{info_id}', json={
        'data': {'type': 'appInfos', 'id': info_id,
                 'relationships': {
                     'primaryCategory': {'data': {'type': 'appCategories', 'id': 'LIFESTYLE'}},
                     'secondaryCategory': {'data': {'type': 'appCategories', 'id': 'ENTERTAINMENT'}}
                 }}
    })
    print(f'Category set: {r.status_code}')

# ---- Step 5: Assign build ----
print('\n=== Step 5: Assign build ===')
r = api('GET', f'/builds?filter[app]={APP_ID}&filter[processingState]=VALID&sort=-uploadedDate&limit=1')
build_data = r.json().get('data', [])
if not build_data:
    print('No valid build found. Run CI/CD first.')
    sys.exit(1)
build_id = build_data[0]['id']
build_ver = build_data[0]['attributes'].get('version', '?')
print(f'Build: {build_ver} id={build_id}')

# Export compliance
api('PATCH', f'/builds/{build_id}',
    json={'data': {'type': 'builds', 'id': build_id, 'attributes': {'usesNonExemptEncryption': False}}})

# Assign build to version
r = api('PATCH', f'/appStoreVersions/{version_id}/relationships/build',
    json={'data': {'type': 'builds', 'id': build_id}})
print(f'Build assigned: {r.status_code}')

# ---- Step 6: Submit for review ----
print('\n=== Step 6: Submit for review ===')

# Cancel blocking submissions
for state in ['UNRESOLVED_ISSUES']:
    r = api('GET', f'/apps/{APP_ID}/reviewSubmissions?filter[state]={state}')
    for sub in r.json().get('data', []):
        sid = sub['id']
        api('PATCH', f'/reviewSubmissions/{sid}',
            json={'data': {'type': 'reviewSubmissions', 'id': sid, 'attributes': {'canceled': True}}})
        print(f'Canceled submission {sid[:8]}')

time.sleep(3)

r = api('POST', '/reviewSubmissions', json={
    'data': {'type': 'reviewSubmissions',
             'relationships': {'app': {'data': {'type': 'apps', 'id': APP_ID}}}}
})
if not r.ok:
    print(f'Create submission failed: {r.status_code} {r.text[:300]}')
    sys.exit(1)
sub_id = r.json()['data']['id']

time.sleep(2)
r = api('POST', '/reviewSubmissionItems', json={
    'data': {'type': 'reviewSubmissionItems',
             'relationships': {
                 'reviewSubmission': {'data': {'type': 'reviewSubmissions', 'id': sub_id}},
                 'appStoreVersion': {'data': {'type': 'appStoreVersions', 'id': version_id}}
             }}
})
if not r.ok:
    print(f'Add item failed: {r.status_code} {r.text[:300]}')
    api('PATCH', f'/reviewSubmissions/{sub_id}',
        json={'data': {'type': 'reviewSubmissions', 'id': sub_id, 'attributes': {'canceled': True}}})
    sys.exit(1)
print(f'Item added: {r.status_code}')

time.sleep(2)
r = api('PATCH', f'/reviewSubmissions/{sub_id}',
    json={'data': {'type': 'reviewSubmissions', 'id': sub_id, 'attributes': {'submitted': True}}})
if r.ok:
    print(f'\nSUBMITTED! State: {r.json()["data"]["attributes"]["state"]}')
else:
    print(f'Submit failed: {r.status_code} {r.text[:300]}')
