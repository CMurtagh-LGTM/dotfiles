import datetime
import email.policy
import os
import platform
import subprocess
from email.parser import BytesHeaderParser
from email.utils import parsedate_to_datetime

from rich.columns import Columns
from rich.console import Console
from rich.layout import Layout
from rich.padding import Padding
from rich.panel import Panel
from rich.rule import Rule
from rich.text import Text

home = os.environ["HOME"]

# Get the neofetch
fetch = subprocess.run(["neofetch"], check=True, capture_output=True).stdout.decode(
    "utf-8"
)
# Obtain the calendar events
calendar = subprocess.run(
    [
        "calcurse",
        "-r30",
        "--format-apt=%S\n%m\n",
        "--format-event=*\n%m\n",
        "--format-todo=TODO %p\n%m\n" "--output-datefmt=%d/%m/%Y",
    ],
    check=True,
    capture_output=True,
).stdout.decode("utf-8")
# Get the names of the folders the email accounts are in
mail_accounts = [
    x
    for x in os.listdir(os.path.join(home, ".local/share/mail/"))
    if not x.startswith(".")
]
# Loop through the emails in each account, getting sender, date and subject
mail = {}
email_parser = BytesHeaderParser(policy=email.policy.default)
for account in mail_accounts:
    m = []

    for mail_path in os.scandir(
        os.path.join(home, ".local/share/mail", account, "INBOX/new")
    ):
        fd = open(mail_path, "rb")
        parsed = email_parser.parse(fd)
        n = {}
        n["from"] = parsed.get("From")
        n["date"] = parsedate_to_datetime(parsed.get("Date")).date().isoformat()
        n["subject"] = parsed.get("Subject")
        fd.close()
        m.append(n)

    mail[account] = m

# Do some text preprocessing
calendar = calendar.split("\n\n")
calendar = [event.rstrip().split("\n", 1) for event in calendar]
fetch = Text.from_ansi(fetch)

console = Console()

# Construct the looped panels
events = Columns([Panel(event[1], title=event[0][:-1]) for event in calendar])
# Have a panel for each account with panels on mail inside the account
mails = Columns(
    [
        Panel(
            Columns(
                [
                    Panel("\n".join([x["from"], x["subject"]]), title=x["date"])
                    for x in y
                ],
                expand=True,
                column_first=True,
            ),
            title=name,
        )
        for name, y in mail.items()
    ],
    column_first=True,
)

# Partition the screen into manageable chunks
layout = Layout()
layout.split_column(
    Layout(Padding(""), name="padding", size=1),
    Layout(Rule(platform.node()), name="title", size=1),
    Layout(name="content"),
)
timed_layout = Layout()
timed_layout.split_row(
    Layout(Panel(events, title="Calendar"), name="calendar"),
    Layout(Panel(mails, title="Emails"), name="email"),
)
layout["content"].split_row(
    Layout(Panel(fetch), name="fetch"),
    Layout(Panel(timed_layout, title=str(datetime.date.today())), name="timed", ratio=4),
)

# Do it
console.print(layout)
