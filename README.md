# IOS-мессенджер з використанням платформи Firebase

Застосунок був розроблений з використанням патернів проєктування, а саме:
- Model-View-Controller;
- Solid: single responsibility principle, open/closed principle, liskov substitution principle, interface segregation principle, dependency inversion principle;
- GRASP: information expert, creator, low coupling, high cohesion, controller, polymorphism, pure fabrication, indirection, protected variations;
- Singleton;
- Observer; 
- та інші. <br><br>
Немало важливу роль у розробці застосунка відіграло інтеграція з платформою від Google - Firebase. Ця платформа надає в режимі реального часу базу даних та бекенд. Також за допомогою Firebase відбувається аутентифікація користувачів, збереження даних, наприклад аватар юзера.
Детальніше про застосунок в скріншотах:
* Сторінка входу:  <br>
<img width="444" alt="Screenshot 2021-05-30 at 21 23 23" src="https://user-images.githubusercontent.com/42568173/120116359-778b4780-c190-11eb-8011-308806f1c058.png"> <br>
* Сторінка реестрації:  <br>
<img width="444" alt="Screenshot 2021-05-30 at 21 24 04" src="https://user-images.githubusercontent.com/42568173/120116395-9d185100-c190-11eb-8e1d-53bfe762f514.png">  <br>
- Сторінка вибору аватару:  <br>
<img width="444" alt="Screenshot 2021-05-30 at 21 24 25" src="https://user-images.githubusercontent.com/42568173/120116458-e5377380-c190-11eb-8f2f-d8b5927452a0.png">  <br>
<img width="444" alt="Screenshot 2021-05-30 at 21 24 33" src="https://user-images.githubusercontent.com/42568173/120116445-dbae0b80-c190-11eb-8697-1195ca582c0b.png">  <br>
- Сторінка профілю:   <br>
<img width="444" alt="Screenshot 2021-05-30 at 21 25 04" src="https://user-images.githubusercontent.com/42568173/120116413-b3261180-c190-11eb-8b71-ada8f99bf0ca.png">  <br>
- Сторінка налаштування:  <br>
<img width="444" alt="Screenshot 2021-05-30 at 21 25 10" src="https://user-images.githubusercontent.com/42568173/120116427-c76a0e80-c190-11eb-9207-4b6fc7488a93.png">  <br>
- Сторінка пошуку користувачів:  <br>
<img width="444" alt="Screenshot 2021-05-30 at 21 25 43" src="https://user-images.githubusercontent.com/42568173/120116592-79093f80-c191-11eb-9320-e97143c7c908.png">  <br>
<img width="444" alt="Screenshot 2021-05-30 at 21 26 24" src="https://user-images.githubusercontent.com/42568173/120116553-537c3600-c191-11eb-9b73-3b19672c596b.png">  <br>
- Сторінка листування:  <br>
<img width="444" alt="Screenshot 2021-05-30 at 21 25 20" src="https://user-images.githubusercontent.com/42568173/120116583-6db61400-c191-11eb-99ff-7945bdd24921.png">  <br>
* Firebase back-end: 
  * Authentication: <br>
  <img width="1338" alt="Screenshot 2021-05-30 at 21 26 59" src="https://user-images.githubusercontent.com/42568173/120116763-59bee200-c192-11eb-813e-0d0cc9efdb4b.png"><br>
  * Realtime database: <br>
  <img width="1338" alt="Screenshot 2021-05-30 at 21 27 26" src="https://user-images.githubusercontent.com/42568173/120116774-65aaa400-c192-11eb-9a92-9deb0cd5b6de.png"><br>
  * Storage:<br>
  <img width="1338" alt="Screenshot 2021-05-30 at 21 27 43" src="https://user-images.githubusercontent.com/42568173/120116784-6c391b80-c192-11eb-9b49-05f8cda808dc.png"><br>
