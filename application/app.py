#import libraries 
import pickle
from flask import Flask, request, json, jsonify 
from flask import render_template, session, url_for, redirect
from flask_wtf import FlaskForm
from wtforms import TextField, SubmitField
import json
import requests
import joblib as joblib  

 #---the filename of the saved model---
#filename = 'diabetes.sav'
filename = 'diabetes.joblib'
 #---load the saved model--- 
#loaded_model = pickle.load(open(filename, 'rb'))
loaded_model = joblib.load(filename)

#create an instance of the Flask class
#app = Flask(__name__)
app = Flask(__name__, template_folder='templates')


@app.route('/',methods=['GET', 'POST'])
def main():
    if request.method == 'GET':
        return(render_template('main.html'))
    if request.method == 'POST':    
        Glucose = request.form['Glucose']
        BMI = request.form['BMI']
        Age = request.form['Age']
        input_variables = pd.DataFrame([[Glucose, BMI, Age]],columns=['Glucose', 'BMI', 'Age'], dtype=float)
        prediction = loaded_model.predict(input_variables)[0]
        if prediction==1:
            diagnosis = "Diabetic"
        else:
            diagnosis = "Not Diabetic"
        return render_template('main.html', original_input={'Glucose':Glucose,'BMI':BMI,'Age':Age},result=diagnosis,) 


    #return(flask.render_template('main.html'))
#app.config['SECRET_KEY']='asecretkey'
#Define a prediction function
#def predict():
    #---get the features to predict---
    #features = request.json    
    #---create the features list for prediction---
    #features_list = [features["Glucose"], 
    #features["BMI"],
    #features["Age"]]
    #---get the prediction class---
    #prediction = loaded_model.predict([features_list])
    #---get the prediction probabilities--- 
    #confidence = loaded_model.predict_proba([features_list])
    #---formulate the response to return to client---
    #response = {}
    #response['prediction'] = int(prediction[0]) 
    #response['confidence'] = str(round(np.amax(confidence[0]) * 100 ,2))
    #if response['prediction']==1:
        #diagnosis = "Diabetic"
    #else:
        #diagnosis = "Not Diabetic"
    #return jsonify(diagnosis)
 #---the filename of the saved model---
#filename = 'diabetes.sav'
#filename = 'diabetes.joblib'
 #---load the saved model--- 
#loaded_model = pickle.load(open(filename, 'rb'))
#loaded_model = joblib.load(filename)
#create a WTForm Class
#class PredictForm(FlaskForm):
    #Glucose = TextField("Glucose")
    #BMI = TextField("BMI")
    #Age = TextField("Age")
    #submit = SubmitField("Predict")
#set up our home page  
#@app.route("/", methods=["GET","POST"])
#def index():   
    #create instance of the form
    #form = PredictForm()      
    #validate the form  
    #if form.validate_on_submit():
        #features['Glucose'] = form.Glucose.data
        #features['BMI'] = form.BMI.data
        #features['Age'] = form.Age.data
        #return redirect(url_for("diagnosis"))
        #return render_template('home.html',form=form)
        #return diagnosis
#define a new prdiction route that processes form input and returns a model prediction  
#@app.route('/predict')  
#def predict_diabetes():      
    #results = predict()    
    #return results
#allows us to run flask using $python REST_API_1.py    
if __name__ == '__main__': 
    app.run()