"""
TestRail integration:
* limited to what we need at this time
* we assume TestRail operates in single suite mode
  i.e., the default, reccomended mode

API reference: http://docs.gurock.com/testrail-api2/start
"""
import os, sys

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import testrail as testrail
import testrailenv_conf as conf_file


class Test_Rail:
    "Wrapper around TestRail's API"
    # Added below to fix PytestCollectionWarning
    __test__ = False

    def __init__(self):
        "Initialize the TestRail objects"
        self.set_testrail_conf()

    def set_testrail_conf(self):
        "Set the TestRail URL and username, password"

        # Set the TestRail URL
        self.testrail_url = conf_file.testrail_url
        self.client = testrail.APIClient(self.testrail_url)

        # TestRail User and Password
        self.client.user = conf_file.testrail_user
        self.client.password = conf_file.testrail_password

    def get_project_id(self, project_name):
        "Get the project ID using project name"
        project_id = None
        projects = self.client.send_get('get_projects')
        for project in projects:
            if project['name'] == project_name:
                project_id = project['id']
                break
        return project_id

    def get_suite_id(self, project_name, suite_name):
        "Get the suite ID using project name and suite name"
        suite_id = None
        project_id = self.get_project_id(project_name)
        suites = self.client.send_get('get_suites/%s' % (project_id))
        for suite in suites:
            if suite['name'] == suite_name:
                suite_id = suite['id']
                break
        return suite_id

    def get_milestone_id(self, project_name, milestone_name):
        "Get the milestone ID using project name and milestone name"
        milestone_id = None
        project_id = self.get_project_id(project_name)
        milestones = self.client.send_get('get_milestones/%s' % (project_id))
        for milestone in milestones:
            if milestone['name'] == milestone_name:
                milestone_id = milestone['id']
                break
        return milestone_id

    def get_user_id(self, user_name):
        "Get the user ID using user name"
        user_id = None
        users = self.client.send_get('get_users')
        for user in users:
            if user['name'] == user_name:
                user_id = user['id']
                break
        return user_id

    def get_run_id(self, project_name, test_run_name):
        "Get the run ID using test name and project name"
        run_id = None
        project_id = self.get_project_id(project_name)
        try:
            test_runs = self.client.send_get('get_runs/%s' % (project_id))
        except Exception as e:
            print('Exception in update_testrail() updating TestRail.')
            print('PYTHON SAYS: ')
            print(e)
        else:
            for test_run in test_runs:
                if test_run['name'] == test_run_name:
                    run_id = test_run['id']
                    break

        return run_id

    def Get_run_details(self, runid):
        TitleList = []
        CaseList = []
        try:
            run_details = self.client.send_get('get_tests/%s' % (runid))
            for detail in run_details:
                TitleList.append(detail['title'])
                CaseList.append(detail['case_id'])
            TestcaseDetails = list(zip(TitleList, CaseList))
        except Exception as e:
            print('Exception in update_testrail() updating TestRail.')
            print('PYTHON SAYS: ')
            print(e)
        return TestcaseDetails

    def get_cases(self, case):
        "Get the run ID using test name and project name"
        try:
            cases = self.client.send_get('get_case/%s' % (case))
        except Exception as e:
            print('Exception in update_testrail() updating TestRail.')
            print('PYTHON SAYS: ')
            print(e)
        return cases

    def create_milestone(self, project_name, milestone_name, milestone_description=""):
        "Create a new milestone if it does not already exist"
        milestone_id = self.get_milestone_id(project_name, milestone_name)
        if milestone_id is None:
            project_id = self.get_project_id(project_name)
            if project_id is not None:
                try:
                    data = {'name': milestone_name,
                            'description': milestone_description}
                    self.client.send_post('add_milestone/%s' % str(project_id),
                                          data)
                except Exception as e:
                    print('Exception in create_new_project() creating new project.')
                    print('PYTHON SAYS: ')
                    print(e)
                else:
                    print('Created the milestone: %s' % milestone_name)
        else:
            print("Milestone '%s' already exists" % milestone_name)

    def create_new_project(self, new_project_name, project_description, show_announcement, suite_mode):
        "Create a new project if it does not already exist"
        project_id = self.get_project_id(new_project_name)
        if project_id is None:
            try:
                self.client.send_post('add_project',
                                      {'name': new_project_name,
                                       'announcement': project_description,
                                       'show_announcement': show_announcement,
                                       'suite_mode': suite_mode, })
            except Exception as e:
                print('Exception in create_new_project() creating new project.')
                print('PYTHON SAYS: ')
                print(e)
        else:
            print("Project already exists %s" % new_project_name)

    def create_test_run(self, project_name, test_run_name, milestone_name=None, description="", suite_name=None,
                        case_ids=[], assigned_to=None):
        "Create a new test run if it does not already exist"
        project_id = self.get_project_id(project_name)
        test_run_id = self.get_run_id(project_name, test_run_name)
        if project_id is not None and test_run_id is None:
            data = {}
            if suite_name is not None:
                suite_id = self.get_suite_id(project_name, suite_name)
                if suite_id is not None:
                    data['suite_id'] = suite_id
            data['name'] = test_run_name
            data['description'] = description
            if milestone_name is not None:
                milestone_id = self.get_milestone_id(project_name, milestone_name)
                if milestone_id is not None:
                    data['milestone_id'] = milestone_id
            if assigned_to is not None:
                assignedto_id = self.get_user_id(assigned_to)
                if assignedto_id is not None:
                    data['assignedto_id'] = assignedto_id
            if len(case_ids) > 0:
                data['case_ids'] = case_ids
                data['include_all'] = False

            try:
                self.client.send_post('add_run/%s' % (project_id), data)
            except Exception as e:
                print('Exception in create_test_run() Creating Test Run.')
                print('PYTHON SAYS: ')
                print(e)
            else:
                print('Created the test run: %s' % test_run_name)
        else:
            if project_id is None:
                print("Cannot add test run %s because Project %s was not found" % (test_run_name, project_name))
            elif test_run_id is not None:
                print("Test run '%s' already exists" % test_run_name)

    def delete_project(self, new_project_name, project_description):
        "Delete an existing project"
        project_id = self.get_project_id(new_project_name)
        if project_id is not None:
            try:
                self.client.send_post('delete_project/%s' % (project_id), project_description)
            except Exception as e:
                print('Exception in delete_project() deleting project.')
                print('PYTHON SAYS: ')
                print(e)
        else:
            print('Cant delete the project given project name: %s' % (new_project_name))

    def delete_test_run(self, test_run_name, project_name):
        "Delete an existing test run"
        run_id = self.get_run_id(test_run_name, project_name)
        if run_id is not None:
            try:
                self.client.send_post('delete_run/%s' % (run_id), test_run_name)
            except Exception as e:
                print('Exception in update_testrail() updating TestRail.')
                print('PYTHON SAYS: ')
                print(e)
        else:
            print(
                'Cant delete the test run for given project and test run name: %s , %s' % (project_name, test_run_name))

    def test_run_details(self, test_run_name, project_name):
        "Delete an existing test run"
        run_id = self.get_run_id(test_run_name, project_name)
        # run_id= "673"
        # print("run id",run_id)
        titlelist = []
        idlist = []
        runresult = []
        if run_id is not None:
            try:
                result = self.client.send_get('get_tests/%s' % (run_id))
                for i in result:
                    if i['title'].startswith('[1]'):
                        i['title'] = i['title'].replace('[1]', '')
                        titlelist.append(i['title'])
                    else:
                        titlelist.append(i['title'].strip())
                    idlist.append(i['id'])
                runresult = list(zip(titlelist, idlist))
            except Exception as e:
                print('Exception in get run results from TestRail.')
                print('PYTHON SAYS: ')
                print(e)
        else:
            print('Cant find the test run for given project and test run name: %s , %s' % (project_name, test_run_name))
        return runresult

    def update_result_testrail(self, test_id, attachment_path, result_flag, msg=""):
        "Update TestRail for a given run_id and case_id"
        update_flag = False

        status_id = 1 if result_flag == "Passed" else 5

        if (test_id != 'None'):
            try:
                response = self.client.send_post('add_result/' + str(test_id), {'status_id': status_id, 'comment': msg})
                self.client.send_post('add_attachment_to_result/' + str(response['id']), attachment_path)
            except Exception as e:
                print('Exception in update_testrail() updating TestRail.')
                print('PYTHON SAYS: ')
                print(e)
            else:
                print('Updated test result for test id: ' + str(test_id))

        return update_flag

    def update_testrail(self, case_id, run_id, result_flag, msg=""):
        "Update TestRail for a given run_id and case_id"
        update_flag = False

        status_id = 1 if result_flag == "PASS" else 5

        if ((run_id is not None) and (case_id != 'None')):
            try:
                self.client.send_post(
                    'add_result_for_case/%s/%s' % (run_id, case_id),
                    {'status_id': status_id, 'comment': msg})
            except Exception as e:
                print('Exception in update_testrail() updating TestRail.')
                print('PYTHON SAYS: ')
                print(e)
            else:
                print('Updated test result for case: %s in test run: %s\n' % (case_id, run_id))

        return update_flag
