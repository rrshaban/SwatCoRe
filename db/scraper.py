import urllib.request
import html.parser
import re
import json
import lxml.html
from lxml.html.clean import Cleaner

# Top level values, these don't change.
url = 'http://www.trico.haverford.edu/cgi-bin/courseguide/cgi-bin/search.cgi'
user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'
headers = { 'User-Agent' : user_agent}

# Well, maybe this will change later.
semester = 'Fall_2015'

# Priming read.
run_to = '0'
values = { 'smstr'  : semester,
           'campus' : 'Swarthmore',
           'Search' : 'Search',
           'run_tot': run_to }

data = urllib.parse.urlencode(values)
data = data.encode('ascii')
req = urllib.request.Request(url, data, headers)

num_courses = 0
with urllib.request.urlopen(req) as response:
    html = response.read().decode()
    num_courses = int(re.search('(?<=<B>Listing 1 to 50 of )\d+(?=</B>)', html).group(0))

# Request as many webpages we need to read all courses for
# that semester.

cleaner = Cleaner(style=True,
                  links=True,
                  add_nofollow=True,
                  page_structure=False,
                  safe_attrs_only=True,
                  safe_attrs=set(),
                  remove_tags=["b", "a"])

with open("classes.json", 'w') as outfile:
    for i in range(1, num_courses, 50):
        values['run_tot'] = i
        data = urllib.parse.urlencode(values)
        data = data.encode('ascii')
        req = urllib.request.Request(url, data, headers)

        with urllib.request.urlopen(req) as response:
            html = response.read().decode()
            cleaned_html = cleaner.clean_html(html)
            full_tree = lxml.html.fromstring(cleaned_html)
            table = full_tree.find(".//table")

            rows = iter(table)
            throwaway = [col.text for col in next(rows)]
            row_headers = [col.text for col in next(rows)]
            for row in rows:
                class_info = [col.text for col in row]
                obj = dict(zip(row_headers, class_info))
                json.dump(obj, outfile, sort_keys=True, indent=4)
