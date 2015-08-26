# Goal: for each class populate the database with:
#       is it a writing course?
#       is it a First Year Seminar?
#       does it have a lab?
#       how many credit hours does it fulfill?
#       what are the prerequisite classes? (if any?)
#       does it qualify for Natural Science and Engineering Practicum?
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
#   "name": "Bioinformatics",
#   "dept": "CPSC",
#   "crn": 068,
#   "prereqs": ["http://
#                     www.swarthmore.edu/cc_computerscience.xml#CPSC_035"],
#   "credit": 1.0,
#   "writing": false,
#   "lab": true,
#   "FYS": false,
#   "NSEP": false
# } ]

import re
import json
import lxml.html
from bs4 import BeautifulSoup
from bs4 import NavigableString
import requests

# Top level values: these don't change.
#
# Url to source page
catalog = 'http://catalog.swarthmore.edu/'
# Regex for extracting relevant info from the onclick function in the links
pattern = r"""<a href="#" onclick="showCourse\('(?P<catoid>\d+)', '(?P<coid>\d+)',this, '(?P<display_options>.+)'\); return false;">(?P<crn>.*)\.(?P<name>.*)<\/a>"""
# Because for some weird reason if you use the scraped department urls,
# the rest of the scraping doesn't work.
departments = ['Arabic',
'Art',
'Asian-Studies'
'Biology',
'Black-Studies',
'Chemistry-And-Biochemistry',
'Chinese',
'Classics',
'Cognitive-Science',
'Comparative-Literature',
'Computer-Science',
'Dance',
'Economics',
'Educational-Studies',
'Engineering',
'English-Literature',
'Environmental-Studies',
'Film-And-Media-Studies',
'French-And-Francophone-Studies',
'Gender-And-Sexuality-Studies',
'German-Studies',
'Interpretation-Theory',
'Islamic-Studies',
'Japanese',
'Latin-American-And-Latino-Studies',
'Linguistics',
'Mathematics-and-Statistics',
'Medieval-Studies',
'Music',
'Peace-And-Conflict-Studies',
'Philosophy',
'Physics-And-Astronomy',
'Political-Science',
'Psychology',
'Public-Policy',
'Religion',
'Russian',
'Sociology-And-Anthropology',
'Spanish',
'Theater']

# Returns a list of department pages
def get_department_urls():
    # For scraping the department urls - currently doesnt work for some reason
    '''catalog_response = requests.get(catalog)
    soup = BeautifulSoup(catalog_response.content, 'lxml')

    department_urls = []
    object_attributes = soup.select('a[href^="preview_program"]')
    link_pattern = r'<a href="preview_program\.php\?catoid=7&amp;poid=(\d+)'
    root = catalog + 'preview_program.php?catoid=7&amp;poid='
    for dept in object_attributes:
        match = re.search(link_pattern, unicode(dept))
        if match:
            dept_url = root + match.group(1)
            department_urls.append(dept_url)'''

    # Using the manual department input
    department_urls = []
    for dept in departments:
        department_urls.append('http://www.swarthmore.edu/college-catalog/' + dept)

    print department_urls
    return department_urls


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
    course['name'] = course_url[1][1:]
    course['dept'] = course_url[2]
    if 'First-Year Seminar:' in course_url[2]:
        course['FYS'] = True
    else:
        course['FYS'] = False

    # Scrape!
    course_response = requests.get(course_url[3])
    course_soup = BeautifulSoup(course_response.content, 'lxml')
    course_tag = course_soup.find('div', class_="ajaxcourseindentfix", style=False)
    strings = course_tag.stripped_strings

    # In progress: finding descriptions
    # This is very simplistic and will not properly populate course descriptions
    # that have links or paragraph breaks. However, it is a decent solution for now.
    i = 0
    for string in strings:
        if i == 1:
            course['description'] = string
            break
        else:
            i += 1

    # Other possible method:
    '''# Get description
    description = ""
    flip = True
    start = course_soup.find_all('hr')[0]
    end = start.find_next('br')
    current = start.next_sibling
    # If the course does not have a description
    if not isinstance(current, NavigableString):
        description = 'N/A'
    else:
        while current != end:
            if current.name == 'a':
                description += current.string
            elif current.name == 'p':
                break
            elif current.name == 'span':
                pass
            elif current.name == 'h5':
                pass
            else:
                description += unicode(current)
            current = current.next_sibling

    course['description'] = description'''

    # Get lab, NSEP, writing, credit and prereqs
    for string in strings:
        # Look for keywords in strings
        if 'Lab work required' in string:
            course['lab'] = True
        if 'Natural sciences and engineering practicum' in string:
            course['NSEP'] = True
        if 'Writing course' in string:
            course['writing'] = True
        if 'First-Year Seminar' in string:
            course['FYS'] = True
        if 'credit.' in string and not 'COGS' in string:
            try:
                course['credit'] = float(string.split()[0])
            except Exception:
                course['credit'] = 'N/A'
        if 'prerequisite' in string:
            if 'No prerequisites' in string:
                course['prereqs'] = 'None'

            # In progress: finding prereqs
            '''else:
                match = re.search('(\w{4} \d{3}))', string)'''

        # To catch courses that are crosslisted and don't have descriptions
        # The other course will have (Cross-listed as ... , so it will not be caught
        if '(See' in string:
            course['description'] = 'N/A'



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

    print course
    print ''
    print ''
    return course

# Brings together all scraping data and returns a finished json object
def create_json(course_urls):
    courses = []
    for department in course_urls:
        for course_url in department:
            course = scrape(course_url)
            courses.append(course)

    with open("classes.json", 'w') as outfile:
        json.dump(courses, outfile, indent = 2, separators=(',', ': '))

# Main
urls = []
for url in get_department_urls():
    attributes = get_course_objects(url)
    urls.append(get_urls(attributes))
create_json(urls)
