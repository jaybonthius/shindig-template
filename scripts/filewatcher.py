import glob
import os
import subprocess
import time

from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer
from watchdog.observers.polling import PollingObserver

# File patterns to watch
WATCH_PATTERNS = [
    "pollen/**/*.html",
    "pollen/**/*.html.p",
    "pollen/**/*.pm",
    "./**/*.rkt",
    "./media/images/tldraw/*.tldr",
]

# File extensions to watch and their corresponding commands
# Use lists to store multiple commands
# Use {file} as a placeholder for the filename
EXTENSIONS = {
    ".html": [
        "poetry run djlint {file} --reformat",
    ],
    ".html.p": [
        "python -m scripts.tailwind_sorter.tailwind_sorter --file_path {file}",
        "poetry run djlint {file} --reformat",
        "raco pollen render {file}",
    ],
    ".pm": [
        "python -m scripts.tailwind_sorter.tailwind_sorter --file_path {file}",
        "raco pollen render {file}",
    ],
    ".rkt": [
        "raco fmt -i --width 88 {file}",
        "python -m scripts.tailwind_sorter.tailwind_sorter --file_path {file}",
        # "raco pollen render pollen",
    ],
    ".tldr": [
        "pnpm tldraw export {file} --transparent --output {file_dir}/light.svg",
        "pnpm tldraw export {file} --transparent --output {file_dir}/dark.svg --dark",
        "pnpm tldraw export {file} --transparent --output {file_dir}/light.png --format png",
        "pnpm tldraw export {file} --transparent --output {file_dir}/dark.png --format png --dark",
    ],
}


def process_file(file_path):
    file_dir = os.path.dirname(file_path)
    for ext, commands in EXTENSIONS.items():
        if file_path.endswith(ext):
            for cmd in commands:
                cmd = cmd.format(file=file_path, file_dir=file_dir)
                print(f"Running command: {cmd}")
                subprocess.run(cmd, shell=True)
            break


class FileChangeHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if not event.is_directory:
            process_file(event.src_path)

    def on_created(self, event):
        if not event.is_directory:
            process_file(event.src_path)

    def on_moved(self, event):
        if not event.is_directory:
            process_file(event.dest_path)


def get_watch_dirs():
    watch_dirs = set()
    for pattern in WATCH_PATTERNS:
        for path in glob.glob(pattern, recursive=True):
            watch_dirs.add(os.path.dirname(path))
    return list(watch_dirs)


if __name__ == "__main__":
    event_handler = FileChangeHandler()
    observer = (
        PollingObserver()
    )  # Use PollingObserver for better cross-platform support

    for watch_dir in get_watch_dirs():
        observer.schedule(event_handler, watch_dir, recursive=True)

    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
