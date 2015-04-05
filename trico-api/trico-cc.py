#!/usr/bin/env python
# Author: Adam Portier <aportier@haverford.edu>
# Version: 0.0.1 Jan 22 2015

from flask import (Flask, jsonify, request)
from flask.ext.mongoengine import MongoEngine
from mongoengine.errors import ValidationError
from os.path import (join, abspath)
from datetime import datetime, timedelta
import chardet
import os, re

#####///// Config /////#####
app = Flask(__name__)
app.config["SECRET_KEY"] = "changeThisKey"
app.config["MONGODB_SETTINGS"] = {
        'db':'trico-cc',
        'host':'localhost',
        'port':27017,
        }

db = MongoEngine(app)
valid_years = ['2013','2014','2015']
valid_schools = ['haverford','bryn_mawr','swarthmore']

#####///// RE Patterns /////#####
college_name = re.compile('^({})$'.format('|'.join(valid_schools)))
semester_name = re.compile('^(spring|fall)_({})$'.format('|'.join(valid_years)))

#####///// Models /////#####
class Course(db.Document):
    created = db.DateTimeField(default=datetime.now, required=True)
    college = db.StringField(required=True)
    semester = db.StringField(required=True)
    reg_id = db.StringField(required=True)
    dept_name = db.StringField(required=True)
    number = db.StringField(required=True)
    title = db.StringField(required=True)
    location = db.StringField()
    days = db.ListField(db.StringField())
    start_times = db.ListField(db.StringField())
    end_times = db.ListField(db.StringField()) # some courses have no end times
    instructor = db.StringField()
    misc = db.ListField(db.StringField())

    def __unicode__(self):
        return self.reg_id

    meta = {
            'indexes': ['created','college','reg_id'],
            'ordering': ['created']
            }

#####///// Backend Functions /////#####

# Tries a raw ascii-to-unicode cast. If it fails, asks chardet what the string
# is and trys again. Returns whatever it gets at that point.
def make_string_unicode(s):
    try:
        s = unicode(s)
    except UnicodeDecodeError:
        encoding = chardet.detect(s)['encoding']
        s = unicode(s.decode(encoding))
    return s

# Reads in a course data file for one semester and creates MongoDB documents
# based off the tab-delimited fields it finds
def parse_semester_file(college,semester,semester_file):
    line_number = 0
    created = 0
    error = 0
    college = college.lower()
    semester = semester.lower()
    
    # clear out the current course data for this college and semester,
    # starting from scratch
    for course in Course.objects(college=college,semester=semester):
        course.delete()
    fh = open(semester_file,'r')
    for line in fh:
        line_number += 1
        
        reg_id = ''
        dept_name = ''
        number = ''
        title = ''
        location = ''
        days = []
        times = []
        instructor = ''
        misc = []
        
        try:
            line = make_string_unicode(line.rstrip('\n'))
            fields = line.split('\t')
            if len(fields) > 1:
                reg_id = fields[2]
                dept_name = fields[3]
                number = fields[5]
                title = fields[7]
                location = fields[10]
                days = fields[11].split('|')
                times = fields[12].split('|')
                instructor = fields[16]
                for field in range(17,len(fields)):
                    value = fields[field]
                    if not ((value == u'') or re.match('\s+',value,re.UNICODE)):
                        misc.append(value)
                    
                start_times = []
                end_times = []
                for time in times:
                    try:
                        (start_time, end_time) = time.split('-')
                        start_times.append(start_time)
                        end_times.append(end_time)
                    except ValueError:
                        start_times.append(time)
                    
                course = Course(
                    college = college,
                    semester = semester,
                    reg_id = reg_id,
                    dept_name = dept_name,
                    number = number,
                    title = title,
                    location = location,
                    days = days,
                    start_times = start_times,
                    end_times = end_times,
                    instructor = instructor,
                    misc = misc,
                    )
                
                created += 1
                course.save()
            
        # If the line does not at least contain a title (field 7) error out
        except IndexError:
            print "Too short to ingest: {}:{} {}".format(
                    semester_file,line_number,fields)
            error += 1
            
    fh.close()
    return ({'created':created,'error':error})

#####///// Flask Views //////#####

# Returns a list of all departments for all colleges
@app.route('/api/department/list', methods=['GET'])
def api_list_departments():
    departments = Course.objects.distinct('dept_name')
    return (jsonify({'departments':departments}),200)

# Returns a list of all semesters for all colleges
@app.route('/api/semester/list', methods=['GET'])
def api_list_semseters():
        semesters = Course.objects.distinct('semester')
        return (jsonify({'response':semesters}),200)

# Returns basic information about all courses at the requested school
# and requested semester
@app.route('/api/semester/get', methods=['POST'])
def api_get_semester():
    if not request.json:
        return ('Request not JSON',400)
    else:
        college = ''
        semester = ''
        try:
            college = str(request.json['college']).lower()
            semester = str(request.json['semester']).lower()
            if not college_name.match(college):
                return('Invalid College Name',400)
            if not semester_name.match(semester):
                return('Invalid Semester Name',400)
        except KeyError as e:
            return('Missing key "{}"'.format(e),400)
        
        course_data = Course.objects(
                college=college,
                semester=semester).only('college','semester','reg_id','title')
        
        return (jsonify({'response':course_data}),200)
    
# Returns all information about a requested course, excluding
# MongoDB only fields
@app.route('/api/course/get', methods=['POST'])
def api_get_course():
    if not request.json:
        return ('Request not JSON',400)
    else:
        college = ''
        semester = ''
        reg_id = ''
        try:
            college = request.json['college'].lower()
            semester = request.json['semester'].lower()
            reg_id = request.json['reg_id']
            if not college_name.match(college):
                return('Invalid College Name',400)
            if not semester_name.match(semester):
                return('Invalid Semester Name',400)
        except KeyError as e:
            return('Missing key "{}"'.format(e),400)
        
        course_data = Course.objects(
                 reg_id=reg_id,
                 college=college,
                 semester=semester).exclude('id').exclude('created')
        
        return (jsonify({'response':course_data}),200)

# Constructs a more complex query of course data and returns
# the result, minus the "misc" field
@app.route('/api/course/search', methods=['POST'])
def api_search_course():
    if not request.json:
        return ('Request not JSON',400)
    else:
        college = []
        semester = []
        department = []
        reg_id = ''
        instructor = ''
        days = []
        start_times = []
        keyword = ''
        
        # read in the values sent via JSON, ignoring not included
        # Client provides a JSON list of colleges, normalized for search
        try:
            college = [x.lower() for x in request.json['college']]
        except KeyError as e:
            pass
        
        # Client provides a JSON list of semesters, normalized for search
        try:
            semester = [x.lower() for x in request.json['semester']]
        except KeyError as e:
            pass
        
        # Client provides a JSON list of departments
        try:
            department = [x.lower() for x in request.json['department']]
        except KeyError as e:
            pass
        
        # Client provides a course number string, which
        # matches the reg_id of a document
        try:
            reg_id = request.json['reg_id']
        except KeyError as e:
            pass
        
        # Client provides all or part of an instructor's name,
        # which gets converted to a regex and used for search
        try:
            instructor_pattern = request.json['instructor']
            instructor = re.compile('{}'.format(instructor_pattern),
                re.IGNORECASE|re.UNICODE)
        except KeyError as e:
            pass
        
        # Client provides a JSON list of days, normalized for search (upper)
        try:
            days = [x.upper() for x in request.json['days']]
        except KeyError as e:
            pass
        
        # Client provides a JSON list of start times
        try:
            start_times = request.json['start_times']
        except KeyError as e:
            pass
        
        # Client provides a regular expression string,
        # which can be used to search a few fields in documents
        try:
            keyword_pattern = request.json['keyword'].lower()
            keyword = re.compile('{}'.format(keyword_pattern),
                re.IGNORECASE|re.UNICODE)
        except KeyError as e:
            pass
        
        # creates a blank dictionary object to hold the query being built below
        query_dict = {}
        
        # test each searchable "thing" and if valid include it in the query
        if len(college) > 0:
            query_dict.update({"college":{"$in":college}})
        if len(semester) > 0:
            query_dict.update({"semester":{"$in":semester}})
        if len(department) > 0:
            query_dict.update({"department":{"$in":department}})
        if not reg_id == '':
            query_dict.update({"reg_id":course_number})
        
        # if the type of "instructor" has become a regex object, include it
        if isinstance(instructor,type(re.compile(''))):
            query_dict.update({"instructor":instructor})

        if len(days) > 0:
            query_dict.update({"days":{"$in":days}})
        if len(start_times) > 0:
            query_dict.update({"start_times":{"$in":start_times}})
            
        # if the type of "keyword" has become a regex object, include it
        if isinstance(keyword, type(re.compile(''))):
            # TODO: Need to figure out how to address response parametrically so
            # valid responses can come from matches to title or misc fields
            query_dict.update({"title":keyword})
            
        course_data = Course.objects(__raw__=query_dict).only(
                "college",
                "semester",
                "reg_id",
                "instructor",
                "title",
                "days",
                "start_times",
                "end_times")
        
        return (jsonify({'response':course_data}),200)

# View to force the Flask API to ingest a single semester file into MongoDB
#app.route('/api/ingest/semester', methods=['POST'])
def ingest_course_data():
    #db_base = abspath(join(os.getcwd(), 'db'))
    db_base = '/opt/trico-cc/db'
    college_basedir = {
    'haverford':'Haverford',
    'bryn_mawr':'Bryn_Mawr',
    'swarthmore':'Swarthmore'
    }
    if not request.json:
        return ('Request not JSON',400)
    else:
        college = ''
        semester = ''
        found = False
        try:
            college = str(request.json['college']).lower()
            semester = str(request.json['semester']).lower()
            if not college_name.match(college):
                return('Invalid College Name',400)
            if not semester_name.match(semester):
                return('Invalid Semester Name',400)
        except KeyError as e:
            return('Missing key "{}"'.format(e),400)

        college_path = abspath(join(db_base, college_basedir[college]))
        semester_file_re = re.compile('^{}$'.format(semester),re.IGNORECASE)
        for (dirpath, dirnames, filenames) in os.walk(college_path):
            for filename in filenames:
                if semester_file_re.match(filename):
                    found = True
                    semester_file = abspath(join(college_path, filename))
                    response = parse_semester_file(
                            college,semester,semester_file)
                    return (jsonify(response),201)
            if not found:
                return('No such semester file found: {}'.format(semester),400)


# View to force the Flask API to ingest all available course data into MongoDB
#app.route('/api/ingest/bulk', methods=['GET'])
def bulk_ingest_course_data():
    #db_base = abspath(join(os.getcwd(), 'db'))
    db_base = '/opt/trico-cc/db'
    college_basedir = {
    'haverford':'Haverford',
    'bryn_mawr':'Bryn_Mawr',
    'swarthmore':'Swarthmore'
    }
    final_response = {'created':0,'error':0}
    for college in college_basedir.keys():
        college_path = abspath(join(db_base, college_basedir[college]))
        for (dirpath, dirnames, filenames) in os.walk(college_path):
            for filename in filenames:
                if semester_name.match(filename.lower()): 
                    semester_file = abspath(join(college_path, filename))
                    response = parse_semester_file(
                            college,filename,semester_file)
                    final_response['created'] += response['created']
                    final_response['error'] += response['error']
    return (jsonify(final_response),201)

#####///// MAIN /////#####
if __name__ == '__main__':
    app.run(debug=True)
