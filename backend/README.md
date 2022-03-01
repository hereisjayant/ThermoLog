## To Run it Locally
If you are running this the first time, do
`python3 -m venv env`   then
` python3 -m pip install -r requirements.txt`

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

# Deployment
It is now deployed at 
`https://mighty-tundra-85273.herokuapp.com/`

To deploy, first login
`heroku login`
using the cpen391 thermolog email

then deploy this subdirectory
`git subtree push --prefix backend/ heroku main`

# Development Resources
1. solving Win32 error when installing [firebase_admin ](https://stackoverflow.com/questions/51912999/could-not-install-packages-due-to-an-environmenterror-winerror-5-access-is-de) 
2. freeze requirements: `pip freeze > requirements.txt`
3. Deploy Git subdirectory to [Heroku](https://medium.com/@shalandy/deploy-git-subdirectory-to-heroku-ea05e95fce1f)

