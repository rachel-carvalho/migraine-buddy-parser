# migraine-buddy-parser
Parser for [Migraine Buddy](https://migrainebuddy.com/)'s exported report html which generates [Migraine Québec's calendar (fr)](https://migrainequebec.com/ressources/calendrier-de-la-migraine/).

## How it works

### 1. Export report HTML from app
Go to the app and export data "For my doctor" for whatever period you wish, including notes and health events as a "Web Link".

![Screenshot: app menu](docs/app-1-menu.png)
![Screenshot: period selection](docs/app-2-dates.png)
![Screenshot: entry attribute selection](docs/app-3-attributes.png)
![Screenshot: export as Web Link](docs/app-3-export.png)

Save the page HTML into Migraine Buddy Parser's `input` folder.
```bash
curl https://reports.healint.com/mb/MigraineBuddy_XXXXXXXX.html > ~/migraine-buddy-parser/input/report.html
```

### 2. Use tool to generate MigraineQC calendar HTML
Run parser to generate calendar.

```bash
npm start > calendar.html
```
### 3. Done!
![Screenshot: resulting calendar](docs/calendar.png)
