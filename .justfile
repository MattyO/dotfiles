set shell := ["bash", "-c"]

collect:
    #!/usr/bin/env python3
    import json
    import shutil
    import os
    from pathlib import Path

    print("Reading file to collect from files.json")
    files = None
    with open("files.json") as f:
        files = json.load(f)
    for file_from_json in files:
        full_destination_path = Path(os.path.expanduser(file_from_json['destination'])).resolve()
        if full_destination_path.is_file():
            print('copying file')
            shutil.copy(full_destination_path, os.path.join('files', file_from_json['file']))
        elif full_destination_path.is_dir():
            print('copying directory')
            shutil.copytree(full_destination_path, os.path.join('files', file_from_json['file']))

    #grep -v '^\s*#\|^\s*$' whitelist | xargs -I{} sh -c '[ -e "{}" ] && cp -r "{}" dotfiles/'
install:
        echo 'Implement: Run Dev server.'
