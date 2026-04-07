#!/usr/bin/env python3
import os
import subprocess
import sys
from github import Auth, Github

src_dir = os.getenv('SRC_ROOT', os.path.expanduser('~') + '/src')
print ('Source directory is', src_dir)

try:
    result = subprocess.run(['gh', 'auth', 'token'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
except FileNotFoundError:
    print("Error: 'gh' CLI was not found. Install GitHub CLI and run 'gh auth login'.", file=sys.stderr)
    sys.exit(1)

access_token = result.stdout.decode('utf-8').strip()
if result.returncode != 0 or not access_token:
    err = result.stderr.decode('utf-8').strip()
    print('Error: could not retrieve GitHub access token from gh CLI.', file=sys.stderr)
    if err:
        print(err, file=sys.stderr)
    print("Run 'gh auth login' and try again.", file=sys.stderr)
    sys.exit(1)

g = Github(auth=Auth.Token(access_token))
for r in g.get_user().get_repos():
    if not r.archived and not r.fork:
        org_path = src_dir + '/' + r.owner.login
        if not os.path.isdir(org_path):
            os.makedirs(org_path)
        repo_path = org_path + '/' + r.name
        if not os.path.isdir(repo_path):
            print('Cloning', r.owner.login+'/'+r.name)
            subprocess.check_call(['git', 'clone', r.ssh_url], cwd=org_path)
