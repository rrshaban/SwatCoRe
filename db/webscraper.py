# Goal: for each class populate the database with:
#       is it a writing course?
#       is it a First Year Seminar?
#       does it have a lab?
#       how many credit hours does it fulfill?
#       what are the prerequisite classes? (if any?)
#
# Plan of action: from this url http://www.swarthmore.edu/college-catalog
#       go through every department page,
#       e.g. http://www.swarthmore.edu/college-catalog/computer-science
#       and extract the information
#
# example html response:
#<h5><a name="CPSC_068" id="CPSC_068"></a>CPSC 068. Bioinformatics</h5>
#<p>(Cross-listed as <a href="http://www.swarthmore.edu/cc_linguistics.xml#
#LING_020">BIOL</a> 068)<br /> This course is an introduction to the fields of
#bioinformatics and computational biology, with a central focus on algorithms
#and their application to a diverse set of computational problems in molecular
#biology. Computational themes will include dynamic programming, greedy algorithms,
#supervised learning and classification, data clustering, trees, graphical models,
#data management, and structured data representation. Applications will include
#genetic sequence analysis, pairwise-sequence alignment, phylogenetic trees,
#motif finding, gene-expression analysis, and protein-structure prediction.
#No prior biology experience is necessary.<br /> Prerequisite: <a href="http://
#www.swarthmore.edu/cc_computerscience.xml#CPSC_035">CPSC 035</a> required.<br
#/> Lab work required.<br /> 1 credit.<br /> Fall 2014. Soni.</p>`
#
# Desired json output:
# [ {
#   "Course Name": "Bioinformatics",
#   "Department": "CPSC",
#   "Course ID": 068,
#   "Prerequisites": ["http://
#                     www.swarthmore.edu/cc_computerscience.xml#CPSC_035"],
#   "Credits": 1,
#   "Writing Class": false,
#   "Laboratory": true,
#   "First Year Seminar": false
# } ]

#import html.parser
#import re
import json
import lxml.html
#from lxml.html.clean import Cleaner
from bs4 import BeautifulSoup
import requests

# Top level values, these don't change.
url = 'http://www.swarthmore.edu/college-catalog/computer-science'
response = requests.get(url)
soup = BeautifulSoup(response.content, 'lxml')
content_soup = soup.find("div", "content") #Includes all info about the dept.

course_soup = content_soup.find('h3', string="Courses").parent.next_siblings


courses = []
course = {}
for sibling in course_soup:
    #print sibling
    if sibling.name == "h5":
        # First half of class data

        if not course:
            #new class
            title_string = unicode(sibling.contents[1]) # a string with format "CPSC 068. Bioinformatics"
            dept = title_string.split()[0]
            crn = title_string.split()[1][:-1] # to remove period
            name = ' '.join(title_string.split()[2:]) # to join remaining words into the course name

            course['name'] =  name
            course['dept'] = dept
            course['crn'] = crn
        
            if 'First-Year Seminar:' in name:
                course['FYS'] = True
            else:
                course['FYS'] = False

        else:
            # a class exists with no description, save to output
            course['lab'] = 'N/A'
            course['NSEP'] = 'N/A'
            course['writing'] = 'N/A'
            course['credit'] = 'N/A'

            # save
            courses.append(course)

            # reset
            course = {}

    if sibling.name == "p":
        # Second half of class data

        # Look for keys in strings
        for string in sibling.stripped_strings:
            if 'Lab work required' in string:
                #print 'lab = true'
                course['lab'] = True
            if 'Natural sciences and engineering practicum' in string:
                #print 'NSEP = true'
                course['NSEP'] = True
            if 'Writing course' in string:
                #print 'writing = true'
                course['writing'] = True
            if 'credit.' in string and not 'COGS' in string:
                #print string.split()[0] + ' credit'
                course['credit'] = float(string.split()[0])

        # If key not found in strings, then trait does not apply
        if course.get('lab') == None:
            course['lab'] = False
        if course.get('NSEP') == None:
            course['NSEP'] = False
        if course.get('writing') == None:
            course['writing'] = False
        if course.get('credit') == None:
            course['credit'] = 'N/A'

        # save
        courses.append(course)

        # reset
        course = {}

            # still need to figure out how to deal with prerequisites
        # [u'(Cross-listed as ', <a href="http://www.swarthmore.edu/cc_linguisti
        # cs.xml#LING_020">BIOL</a>, u' 068)', <br/>, u' This course is an intro
        # duction to the fields of bioinformatics and computational biology, wit
        # h a central focus on algorithms and their application to a diverse set
        # of computational problems in molecular biology. Computational themes w
        # ill include dynamic programming, greedy algorithms, supervised learnin
        # g and classification, data clustering, trees, graphical models, data m
        # anagement, and structured data representation. Applications will inclu
        # de genetic sequence analysis, pairwise-sequence alignment, phylogeneti
        # c trees, motif finding, gene-expression analysis, and protein-structur
        # e prediction. No prior biology experience is necessary.', <br/>, u' Pr
        # erequisite: ', <a href="http://www.swarthmore.edu/cc_computerscience.x
        # ml#CPSC_035">CPSC 035</a>, u' required.', <br/>, u' Lab work required.
        # ', <br/>, u' 1 credit.', <br/>, u' Fall 2014. Soni.']
#with open("classes.json", 'w') as outfile:
print json.dumps(courses, indent = 2, separators=(',', ': '))
