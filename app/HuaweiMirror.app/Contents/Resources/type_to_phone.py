#!/usr/bin/env python3
"""Type Chinese/English on Mac and paste into the scrcpy window."""
import subprocess
import sys
import tkinter as tk
from tkinter import ttk


def copy_text(text: str) -> None:
    subprocess.run(["pbcopy"], input=text.encode("utf-8"), check=False)


def paste_to_phone() -> None:
    script = """
tell application "System Events"
    set procs to {}
    try
        set procs to name of every process whose background only is false
    end try
end tell
set target to ""
repeat with n in {"scrcpy-player", "scrcpy", "华为镜像", "HuaweiMirror"}
    if procs contains n then
        set target to n as text
        exit repeat
    end if
end repeat
if target is "" then return
tell application "System Events"
    tell process target
        set frontmost to true
    end tell
    delay 0.15
    keystroke "v" using {option down}
end tell
"""
    subprocess.run(["osascript", "-e", script], check=False, capture_output=True)


def send(entry: tk.Entry) -> None:
    text = entry.get()
    if not text:
        return
    copy_text(text)
    paste_to_phone()
    entry.delete(0, tk.END)


def main() -> None:
    root = tk.Tk()
    root.title("发到手机")
    root.attributes("-topmost", True)
    root.resizable(True, False)
    frm = ttk.Frame(root, padding=10)
    frm.pack(fill="both", expand=True)
    ttk.Label(frm, text="在这里输入（可用中文），回车发送到手机输入框").pack(anchor="w")
    entry = ttk.Entry(frm, width=42)
    entry.pack(fill="x", pady=6)
    entry.focus_set()
    btns = ttk.Frame(frm)
    btns.pack(fill="x")
    ttk.Button(btns, text="发送", command=lambda: send(entry)).pack(side="left")
    ttk.Label(btns, text="点进手机输入框后再发送").pack(side="left", padx=8)
    root.bind("<Return>", lambda _e: send(entry))
    root.mainloop()


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        sys.stderr.write(f"{exc}\n")
        sys.exit(1)
