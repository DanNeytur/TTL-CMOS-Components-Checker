# TTL-CMOS-Components-Checker

Final project in BSC electrical & electronics engineering.

last update: 31/07/22- Submission version

## Description

פרויקט זה בוצע במסגרת פרויקט גמר בתכן הנדסי במכללה אקדמית בראודה, כרמיאל.
מטרת הפרויקט הייתה לבנות מערכת אשר תוכל לזהות ולבדוק תקינות של רכיבים לוגיים ממשפחות TTL ו-CMOS. 

למערכת מספר דרכים שבה המשתמש מבצע אינטראקציה עמה. במערכת קיימת תושבת מיוחדת המתאימה לרכיבים באריזת DIP עד 20 רגליים, ובה המשתמש מכניס את הרכיב הנבדק (עם מנוף להכנסה והוצאה מהירה של רכיב מבלי לעקם את רגלי הרכיב). באמצעות 4 לחצנים על גבי הכרטיס פיתוח DE2, המשתמש בוחר איזה פעולות לבצע. על גבי מסך LCD שנמצא בכרטיס פיתוח מופיעות הפעולות לבחירה, רכיבים לבדיקה, ותוצאות הבדיקות. באמצעות רמקול וכרטיס קול  APR9600 מושמעות הודעות קוליות אשר הוקלטו מראש. כמו כן, נדלקות נורות LED ירוקה ואדומה אשר נמצאות גם הן על כרטיס הפיתוח, בהתאם לתוצאות הבדיקות.

עם הפעלת המערכת הודעת "ברוכים הבאים"  תושמע מהרמקול וגם תופיע על מסך הLCD. אחר כך המערכת תדרוש מהמשתמש, באמצעות הודעה קולית והודעה על המסך, לבחור איזו פעולה לבצע-בדיקת תקינות או זיהוי רכיב. 
לאחר בחירה בפעולת הזיהוי, אם זוהה רכיב יודפס שמו על המסך, תושמע הודעה קולית על זיהוי מוצלח ותידלק נורת לד ירוקה.  אם הזיהוי נכשל, תודפס הודעה שלא זוהה רכיב, תושמע הודעה קולית ותידלק נורת לד אדומה.
לאחר בחירה בפעולת בדיקת תקינות, המערכת תדרוש מהמשתמש לבחור רכיב לבדיקה מבין הבדיקות הקיימות במערכת, באמצעות הודעה קולית והודעה על המסך. אם תוצאת הבדיקה מראה כי הרכיב תקין, הודעת "הרכיב תקין" תושמע ותופיע על המסך, כמו כן הנורה הירוקה תידלק. אם תוצאת הבדיקה היא שהרכיב לא תקין, הודעת "הרכיב תקול" תושמע ותופיע על המסך, כמו כן הנורה האדומה תידלק. 
אם המשתמש הכניס את הרכיב הנבדק הפוך וניסה לבצע בדיקה או זיהוי, המערכת תתריע באמצעות הודעה קולית והודעה על המסך על כך. כמו כן, כל עוד הרכיב הפוך, לא יסופק מתח לרכיב הנבדק וגם לא תבוצע בדיקה כלשהי.

### operating principle

* How to run the program
* Step-by-step bullets
```
code blocks for commands
```
## Authors

*Dan Neytur* - [DanNeytur](https://github.com/DanNeytur)

## Acknowledgments

Inspiration, code snippets, etc.
* [LCD controller and User Logic in VHDL and Programming a FPGAs
](https://openlab.citytech.cuny.edu/wang-cet4805/files/2017/04/LCD-controller-and-User-Logic-in-VHDL-and-Programming-a-FPGAs_posted.pdf)
* [LCD 16×2 Pinout, Commands, and Displaying Custom Characters](https://www.electronicsforu.com/technology-trends/learn-electronics/16x2-lcd-pinout-diagram)
