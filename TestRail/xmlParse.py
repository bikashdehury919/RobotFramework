import xml.etree.ElementTree as xmlElementTree

ROBOT_LISTENER_API_VERSION = 3

class RF_Listener:

    def __init__(self):

        self.ROBOT_LISTENER_API_VERSION = 3

    def output_file(self, path):
        testcaseList = []
        statusList = []
        errorlist=[]
        root = xmlElementTree.parse(path).getroot()
        for case in root.findall('./suite/test'):
            testcase = case.attrib.get("name")
            testcaseList.append(testcase)
        for stat in root.findall('./suite/test/status'):
            status = stat.attrib.get("status")
            statusList.append(status)
        for error in root.findall('./suite/test/status'):
            errors = error.iter("status")
            for err in errors:
                errorlist.append(str(err.text))
        return testcaseList,statusList,errorlist

