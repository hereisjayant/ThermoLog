## To Run it Locally
If you are running this the first time, do
`python -m venv env`   then activate env, then
`python -m pip install -r requirements.txt`

every attempts thereafter
on windows, do
`./env/Scripts/activate`
on other OS, do
`source env/bin/activate`

to run the app, do
`python wsgi.py`

to deactivate 
on windows, do
`./env/Scripts/deactivate`
on other OS, do
`source env/bin/deactivate`

# Development and Debugging 
Follow this to run the server in debugging mode and have hot refresh
These command applies to powershell terminals 
first set the environmental variables:

activate virtual environment as mentioned above 

cd into the app directroy in backend then 
`$env:FLASK_ENV = "development"`
`$env:FLASK_APP = "main"`

you can check that the variables are set properly by 
`gci env:`

finally, do
`flask run`

# Deployment
It is now deployed at 
`https://mighty-dusk-83313.herokuapp.com`

To deploy, first login
`heroku login`
`heroku git:remote -a heroku-391`
using the cpen391 thermolog email

then deploy this subdirectory
`git subtree push --prefix backend/ heroku main`

To deploy, first login
`heroku login`
using the cpen391 thermolog email

then deploy this subdirectory
`git subtree push --prefix backend/ heroku main`

# Development Resources
1. freeze Python requirements: `pip freeze > requirements.txt`
2. Deploy Git subdirectory to [Heroku](https://medium.com/@shalandy/deploy-git-subdirectory-to-heroku-ea05e95fce1f)
3. getting started with Python and [MongoDB](https://www.mongodb.com/blog/post/getting-started-with-python-and-mongodb)
