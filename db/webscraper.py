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

# Pretty regex: <a href="#" onclick="showCourse\('(?<catoid>\d+)', '(?<coid>\d+)',this, '(?<display_options>.+)'\); return false;">(?<crn>.*)&nbsp;(?<name>.*)<\/a>

import re
import json
import lxml.html
from bs4 import BeautifulSoup
import requests

# Top level values: these don't change.
#
# Url to source page
url = 'http://www.swarthmore.edu/college-catalog/computer-science'
# Regex for extracting relevant info from the onclick function in the links
pattern = r"""<a href="#" onclick="showCourse\('(?P<catoid>\d+)', '(?P<coid>\d+)',this, '(?P<display_options>.+)'\); return false;">(?P<crn>.*)\.(?P<name>.*)<\/a>"""

# Returns a list of course object attributes
def get_course_objects(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'lxml')

    # Find all links to a course
    object_attributes = soup.find_all("a", onclick=re.compile("showCourse.*"))

    return object_attributes

# Processes a list of object attributes and returns a list of the format:
#       [
#           [ crn,
#             department,
#             name,
#             url ]
#       ]
def get_urls(object_attributes):
    course_urls = []
    #links = links[1] # Comment to run one course only

    for course in object_attributes:
        output = re.search(pattern, unicode(course)) # match regex to link

        # access using:
        catoid = output.group('catoid')
        coid = output.group('coid')
        display_options = output.group('display_options')
        crn = output.group('crn')
        name = output.group('name')

        # Request url based on the regex groups catoid, coid and display_options
        # Format: http://catalog.swarthmore.edu/ajax/preview_course.php?catoid=7&coid=7746&display_options=a:2:{s:8:~location~;s:7:~program~;s:4:~core~;s:4:~4085~;}&show
        course_url = 'http://catalog.swarthmore.edu/ajax/preview_course.php?catoid={}&coid={}&display_options={}&show'.format(catoid, coid, display_options)

        # Separate the CRN from the Department
        # TODO: Check this works
        dept = crn.split()[0]
        crn = crn.split()[1]

        # Add course info and url the list of urls
        course_urls.append([crn, name, dept, course_url])

    return course_urls

# Scrapes a single course page for all relevant information and returns course
# data in a dictionary that can be easily converted to json.
# Note: course_url is of the same format as that of the get_urls() function.
def scrape(course_url):
    # Set up the course object with known values
    course = {}
    course['crn'] = course_url[0]
    course['dept'] = course_url[1]
    course['name'] = course_url[2]
    if 'First-Year Seminar:' in course_url[2]:
        course['FYS'] = True
    else:
        course['FYS'] = False

    # Scrape!
    course_response = requests.get(course_url[3])
    course_soup = BeautifulSoup(course_response.content, 'lxml')
    course_tag = course_soup.find('div', class_="ajaxcourseindentfix", style=False)
    strings = course_tag.stripped_strings

    # Get description
    description = ""
    flip = True
    start = course_soup.find_all('hr')[0]
    end = start.find_next('br')
    current = start.next_sibling
    while current != end:
        if current.name == 'a':
            description += current.string
        elif current.name == 'span':
            pass
        else:
            description += unicode(current)
        current = current.next_sibling

    course['description'] = description

    # Get lab, NSEP, writing, credit and prereqs
    for string in strings:
        # Look for keywords in strings
        if 'Lab work required' in string:
            course['lab'] = True
        if 'Natural sciences and engineering practicum' in string:
            course['NSEP'] = True
        if 'Writing course' in string:
            course['writing'] = True
        if 'credit.' in string and not 'COGS' in string:
            course['credit'] = float(string.split()[0])
        if 'prerequisite' in string:
            if 'No prerequisites' in string:
                course['prereqs'] = 'None'
            else:
                # Add regex for extracting names of prereqs
                pass

    # If keywords not found in strings, then trait does not apply
    if course.get('lab') == None:
        course['lab'] = False
    if course.get('NSEP') == None:
        course['NSEP'] = False
    if course.get('writing') == None:
        course['writing'] = False
    if course.get('credit') == None:
        course['credit'] = 'N/A'
    if course.get('prereqs') == None:
        course['prereqs'] = 'N/A'
    if course.get('description') == None:
        course['description'] = 'N/A'

    return course

# Brings together all scraping data and returns a finished json object
def create_json(course_urls):
    pass


'''
    if 'First-Year Seminar:' in name:
        course['FYS'] = True
    else:
        course['FYS'] = False

    for string in descendants:
        # Look for keys in strings
        if 'Lab work required' in string:
            course['lab'] = True
        if 'Natural sciences and engineering practicum' in string:
            course['NSEP'] = True
        if 'Writing course' in string:
            course['writing'] = True
        if 'credit.' in string and not 'COGS' in string:
            course['credit'] = float(string.split()[0])
        if 'No prerequisites' in string:
            course['prereqs'] = 'None'

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
    print course
    course = {}



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
    #print json.dumps(courses, indent = 2, separators=(',', ': '))'''


attributes = get_course_objects(url)
urls = get_urls(attributes)
scrape(urls[0])
