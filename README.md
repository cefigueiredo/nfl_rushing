# theScore "the Rush" Interview Challenge
At theScore, we are always looking for intelligent, resourceful, full-stack developers to join our growing team. To help us evaluate new talent, we have created this take-home interview question. This question should take you no more than a few hours.

**All candidates must complete this before the possibility of an in-person interview. During the in-person interview, your submitted project will be used as the base for further extensions.**

### Why a take-home challenge?
In-person coding interviews can be stressful and can hide some people's full potential. A take-home gives you a chance work in a less stressful environment and showcase your talent.

We want you to be at your best and most comfortable.

### A bit about our tech stack
As outlined in our job description, you will come across technologies which include a server-side web framework (like Elixir/Phoenix, Ruby on Rails or a modern Javascript framework) and a front-end Javascript framework (like ReactJS)

### Challenge Background
We have sets of records representing football players' rushing statistics. All records have the following attributes:
* `Player` (Player's name)
* `Team` (Player's team abbreviation)
* `Pos` (Player's postion)
* `Att/G` (Rushing Attempts Per Game Average)
* `Att` (Rushing Attempts)
* `Yds` (Total Rushing Yards)
* `Avg` (Rushing Average Yards Per Attempt)
* `Yds/G` (Rushing Yards Per Game)
* `TD` (Total Rushing Touchdowns)
* `Lng` (Longest Rush -- a `T` represents a touchdown occurred)
* `1st` (Rushing First Downs)
* `1st%` (Rushing First Down Percentage)
* `20+` (Rushing 20+ Yards Each)
* `40+` (Rushing 40+ Yards Each)
* `FUM` (Rushing Fumbles)

In this repo is a sample data file [`rushing.json`](/rushing.json).

##### Challenge Requirements
1. Create a web app. This must be able to do the following steps
    1. Create a webpage which displays a table with the contents of [`rushing.json`](/rushing.json)
    2. The user should be able to sort the players by _Total Rushing Yards_, _Longest Rush_ and _Total Rushing Touchdowns_
    3. The user should be able to filter by the player's name
    4. The user should be able to download the sorted data as a CSV, as well as a filtered subset
    
2. The system should be able to potentially support larger sets of data on the order of 10k records.

3. Update the section `Installation and running this solution` in the README file explaining how to run your code

### Submitting a solution
1. Download this repo
2. Complete the problem outlined in the `Requirements` section
3. In your personal public GitHub repo, create a new public repo with this implementation
4. Provide this link to your contact at theScore

We will evaluate you on your ability to solve the problem defined in the requirements section as well as your choice of frameworks, and general coding style.

### Help
If you have any questions regarding requirements, do not hesitate to email your contact at theScore for clarification.

### Installation and running this solution

#### Requirements

The application is built with Phoenix framework for *Elixir 1.10.4*, however all the requirements are encapsulated on a docker container that runs the app.
So, the minimum requirements to run are:

* `docker`: The application was prepared to run on a docker container, that will encapsulate the requirements to run an controlled environment.
* `make`: There is a makefile prepared with the shortcuts for the docker commands to build the images and run the container.

#### To prepare and start the application
```
make    # This is run the receipts to build a docker image and start a container attached to STDOUT
```

After start the container, the app will be accessible on `http://localhost:4000`

Other possible commands are available

* `make build-image`: Build the docker image and compile the the app

* `make rebuild-image`: Rebuild the docker image

* `make start`: The Default command run by `make`. It start the app on a new docker container and attach the STDOUT

* `make start-daemon`: Start the app on a new daemon docker container. The container will restart on failure and when docker restarts, unless it was explicitly stopped.

* `make stop`: Stop the app container.
* `make help`: Shows this help message

**Obs.1**: The app is expected to listen to port 4000/tcp
**Obs.2**: The app will run on `prod` environment unless a `$MIX_ENV` is provided.

Example: 
```
MIX_ENV=dev make build-image
This would build the image to run using `dev` environment.
```

#### Decisions and Commentaries

##### Elixir as Backend

Besides I have used some cool stuff from Elixir on this project. I confess that I used Elixir, and particularly Phoenix, mostly because I knew that it was part of the tools used by the company.

However, while using this tool. I opted to make use of the named Agent Process to store the data source in memory, as I trust that the volume of data (even if it was 10.000) would not be that much of a burden for elixir.

The evolution for that strategy would be either using ETS if the requirements would still consider static files, or a Postgres Database.

##### React as Frontend

The requirements of the project initially does not seem to demand too much of an UI, to really justify an entire frontend framework. 

So, I considered the possibility of using a regular server rendered webpage, with some vanilla javascript for the little DOM fancyness added to the app.

Phoenix LiveView, besides look cool, I was 100% sure that it would be too much for this challenge. I don't really see any benefit of its capabilities on this project, to justify the burder of the maintenance of websockets, for an app that does not have alerts or real time interactions.

Actually the requirements stressed the importance of make an app though to evolve and the idea of scarse resources (when mentioned the 10.000 players).

That is what really made me consider start it already using React components. Because of the easy of mind that Components bring, allowing us to change without too much stress for others moving parts. Not to say that it is probably the most adopted framework today.


