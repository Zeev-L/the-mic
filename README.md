# the-mic

A small collection of personal automation scripts.

## `syncGmailToSheets.gs` — Gmail → Sheets task manager

A Google Apps Script that turns labelled Gmail threads into a live task board in Google Sheets, with two-way sync.

**What it does**
- Reads every thread with the Gmail label `MyTasks` and parses the subject in the form `Category - Task` into a row.
- Writes new tasks into a sheet named `משימות` (Tasks), with columns: Task ID, Category, Task, Status, Urgency, Due date, Notes, Thread ID.
- Adds a **ניהול משימות** (Task management) menu to the spreadsheet with *Refresh* and *Re-apply colors* actions.
- Two-way sync: marking a row `DONE` moves the email to Trash; if an email leaves the `MyTasks` label, its row is auto-marked `DONE`.
- Auto-colors rows by category and highlights the status cell (OPEN / IN PROGRESS / DEPENDENT / DONE).

**Setup**
1. Open your Google Sheet → **Extensions → Apps Script**.
2. Paste the contents of `syncGmailToSheets.gs` and save.
3. Reload the sheet — a **ניהול משימות** menu appears.
4. In Gmail, label the threads you want tracked with `MyTasks` and use subjects like `Work - Send the report`.
5. Run **Refresh** from the menu (authorize on first run).

No API keys or credentials are stored in the script — it runs under your own Google account's Apps Script permissions.
