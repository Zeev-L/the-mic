# 🚀 התקנת מיק — פרומפט לשיתוף / Shareable install prompt

מיק רץ **כולו על החשבון שלך בלבד** — הכל נוצר טרי, אין שום סוד להעביר.
פתחו **Claude Code** והדביקו את אחד הפרומפטים למטה. Claude יעשה כמעט הכל לבד, ויעצור רק לאישורי הרשאה וכמה קליקים.

---

## 🇮🇱 עברית — העתיקו והדביקו ב-Claude Code

```
אני רוצה להתקין אצלי את "מיק" — מנהל משימות שהופך מיילים והזנות ישירות לטבלת משימות חיה ב-Google Sheets, עם לוח Web App (לוח/רשימה/Roadmap), צביעה, מייל סיכום יומי, וכפתור "הוסף אירוע ליומן". עקוב אחרי ה-Runbook המלא ב-README של github.com/Zeev-L/the-mic.

קודם שאל אותי את 4 השאלות האלה, וחכה לתשובות:
1. האם מותקן ומחובר אצלי התוסף "Claude in Chrome", ואני מחובר ב-Chrome לחשבון ה-Google הנכון (זה שעליו מיק ייווצר)?
2. אני על Mac או Windows/Linux? (חשוב רק לצעד לכידת-הדסקטופ.)
3. שפת האפליקציה — עברית או אנגלית?
4. איך אזין משימות — גם דרך מייל-לעצמי (ואז נגדיר תגית + פילטר ב-Gmail), או רק הזנה ישירה בלוח / בבר / בטרמינל (ואז נדלג על הגדרת ה-Gmail)?

אחרי שאענה, בצע את ההתקנה:
- אם "Claude in Chrome" מחובר ועובד — בצע דרך הדפדפן. אם הוא חסום או לא זמין (למשל ניווט לדומיינים של Google נחסם) — עבור אוטומטית ל"מסלול clasp" מהטרמינל שמתואר ב-README (התקנת clasp, login, יצירת פרויקט מקושר, push, ופריסה). בשני המקרים הכן את כל הקוד בעצמך.
- בצע: יצירת Google Sheet + Apps Script מקושר; התקנת הקוד (Code.gs מהקובץ syncGmailToSheets.TXT + קובץ HTML בשם WebApp מהקובץ WebApp.html); סנכרון/אתחול ראשון; ושתי פריסות Web App — UI ב-"Only myself" (זו כתובת הלוח) ו-webhook ב-"Anyone, even anonymous" (הכתובת הסודית ללכידה מהדסקטופ).
- אם בחרתי אנגלית — קבע Script Property בשם APP_LANG בערך en, וגם קבע MIK_LANG=en בקובץ ~/.mik/config (כדי שגם קיצור הדרך בבר יהיה באנגלית).
- אם בחרתי גם מייל — הנחה אותי ליצור תגית MyTasks ופילטר from:me to:me -{cc:me bcc:me} (Skip Inbox + Apply label). אל תחיל את הפילטר אחורנית.
- כדי להפעיל את כפתור "🗓️ הוסף אירוע ליומן" בלוח — הנחה אותי להריץ פעם אחת בתפריט הגיליון: ניהול משימות → 📅 אשר גישה ליומן, ולאשר את הרשאת ה-Calendar.
- לכידה מהדסקטופ (Mac/Linux בלבד): הרץ ./desktop/install.sh ומלא את ~/.mik/config בשתי הכתובות. ב-Windows דלג — אשתמש בלוח ובשורת ההוספה המהירה.

עצור רק בצעדים שחייבים אותי: אישורי OAuth ואישורי-קליק קצרים. את כל השאר בצע אוטונומית. אל תדפיס בצ'אט את כתובת ה-webhook הסודית — כתוב אותה ישירות ל-~/.mik/config.
```

---

## 🇬🇧 English — copy & paste into Claude Code

```
I want to install "Mik" for myself — a task manager that turns emails and direct entries into a live task table in Google Sheets, with a Web App board (Board / List / Roadmap), auto-coloring, a daily summary email, and an "Add to Calendar" button. Follow the full Runbook in the README of github.com/Zeev-L/the-mic.

First, ask me these 4 questions and wait for my answers:
1. Do I have the "Claude in Chrome" extension installed and connected, and am I signed into the correct Google account in Chrome (the one Mik will live on)?
2. Am I on Mac or Windows/Linux? (Only matters for the desktop-capture step.)
3. App language — Hebrew or English?
4. How will I add tasks — also via email-to-myself (then we'll set up a Gmail label + filter), or direct entry only in the board / bar / terminal (then skip the Gmail setup)?

After I answer, do the install:
- If "Claude in Chrome" is connected and working — do it through the browser. If it's blocked or unavailable (e.g. navigation to Google domains is blocked) — automatically switch to the "clasp path" from the terminal described in the README (install clasp, login, create a bound project, push, and deploy). Either way, prepare all the code yourself.
- Do: create a Google Sheet + bound Apps Script; install the code (Code.gs from syncGmailToSheets.TXT + an HTML file named WebApp from WebApp.html); first sync/init; and two Web App deployments — UI as "Only myself" (this is the board URL) and a webhook as "Anyone, even anonymous" (the secret URL for desktop capture).
- If I chose English — set a Script Property named APP_LANG to en, and also set MIK_LANG=en in ~/.mik/config (so the menu-bar quick-add is in English too).
- If I chose email too — guide me to create a MyTasks label and a filter from:me to:me -{cc:me bcc:me} (Skip Inbox + Apply label). Do NOT apply the filter retroactively.
- To enable the "🗓️ Add to Calendar" button in the board — guide me to run once from the sheet menu: Task Manager → 📅 Authorize Calendar, and approve the Calendar permission.
- Desktop capture (Mac/Linux only): run ./desktop/install.sh and fill ~/.mik/config with the two URLs. On Windows, skip it — I'll use the board and the quick-add bar.

Stop only for steps that require me: OAuth approvals and a few clicks. Do everything else autonomously. Never print the secret webhook URL in chat — write it directly into ~/.mik/config.
```
