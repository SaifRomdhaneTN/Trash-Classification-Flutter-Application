# Trash-Classification-Flutter-Application
This is my submition for a challenge in TWISE NIGHT Challenge 2025 using Flutter and AI.

In this challenge I was tasked with creating a mobile appliation that uses AI in order to determine if a trash is dirty or not. in other words, if the trash is outside the dumpster or not.

In this repo you will find 2 folders : 
  * Output
  * Source

In the output you will find : 

  * **`Data`** : A folder that contains the photos for training and testing the model.
  * **`Train.py`** : The code that trains the model ResNet50 on The data provided.
  * **`Test.py`** : The code that Tests the model and shows that it has a 80 to 82% accuracy.
  * **`app.py`** : The  Code that generates an API for the application to use.
  * **`Trash Classifier.apk`** : the flutter generated Android mobile application.

And in Source you will Find : 
  * **`The PyCharm Project in a folder called TrashClass`**:I included the whole pycharm Project because the virtual enviroment that it provides is needed to run the api. However you don't need PyCharm   
  itself, just the files and the running will be using the cmd.
  * **`The flutter Project/code`** : This includes the pubsac.yaml for the libaries i have used as well as the main.dart file.




# CARFUL !!!!!


**` In order to run test the application you have to go through these steps `** : 

  1-First of all, the model is already trained and saved in the file **`resnet50_trash_classifier.pth`**, However if you want to try the code for yourself, feel free to do so. Keep in mind though that it 
  does take some time to train the model
  
  2-To run the API,i advice you to download the pycharm project since it contains the libaries that i have used. After that open the **`CMD`**, and navigate to the Folder in which **`app.py`** is located.
  
  3-Run  **`.venv\Scripts\activate`** and then **`uvicorn app:app --host 0.0.0.0 --port 8000`**
  
  4-after the API is up and running , install the APK and you should be able to use the application from your phone to upload or take an image to test.
  
  5-Alternativly you can upload the Dataset on google Collab, and then rerun the codes of training and The API.
  

  Here is a small demo of the application :
  
https://github.com/user-attachments/assets/acff2bd5-7e29-4592-99ce-d4d7e357c7cb



