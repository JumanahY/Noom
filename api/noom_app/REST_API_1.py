#import libraries 
import pickle
from flask import Flask, request, json, jsonify 
import numpy as np 
import json
import requests
import joblib as joblib  
#create an instance of the Flask class
app = Flask(__name__)
#Define a prediction function
def predict():
    #---get the features to predict---
    features = request.json    
    #---create the features list for prediction---
    features_list = [features["Glucose"], 
    features["BMI"],
    features["Age"]]
    #---get the prediction class---
    prediction = loaded_model.predict([features_list])
    #---get the prediction probabilities--- 
    confidence = loaded_model.predict_proba([features_list])
    #---formulate the response to return to client---
    response = {}
    response['prediction'] = int(prediction[0]) 
    response['confidence'] = str(round(np.amax(confidence[0]) * 100 ,2))
    if response['prediction']==1:
        diagnosis = "Diabetic"
    else:
        diagnosis = "Not Diabetic"
    return jsonify(diagnosis)
 #---the filename of the saved model---
#filename = 'diabetes.sav'
filename = 'diabetes.joblib'
 #---load the saved model--- 
#loaded_model = pickle.load(open(filename, 'rb'))
loaded_model = joblib.load(filename)
#set up our home page  
@app.route("/")
def index():    
    return """
    <h1> Welcome to our diabetes prediction service</h1>
    To use this service, make a JSON post request to the / predict url with the following fields:
    <ul>
    <li>Glucose</li>
    <li>BMI</li>
    <li>Age</li>
    </ul>
    """
# define a new route which will accept POST requests and return our model predictions      
@app.route('/predict',methods=['POST'])  
def predict_diabetes():      
    results = predict()    
    return results
#allows us to run flask using $python REST_API_1.py    
if __name__ == '__main__': 
    app.run(debug=True)