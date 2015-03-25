rails g scaffold Course name:string department:string crn:string
rails g model Review content:text overall:integer user:references course:references
