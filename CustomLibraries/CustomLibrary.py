# Developed by Bikash Dehury
from robot.api.deco import library, keyword
from robot.libraries.BuiltIn import BuiltIn
import re
import pandas as pd
import time
import cv2


@library
class CustomLibrary:
    def __init__(self):
        try:
            self.selLib = BuiltIn().get_library_instance("SeleniumLibrary")
        except RuntimeError:
            raise RuntimeError("CustomLibrary requires SeleniumLibrary. Please import it in your .robot file first.")

    @keyword('Parse the input text file')
    def parse_file(self, filename):
        """Reads and extracts from the input file."""
        with open(filename, "r") as file:
            lines = file.readlines()

        rectangle = []
        points = []
        parsing_points = False

        for line in lines:
            line = line.strip()
            if "Rectangle" in line:
                continue
            if "Points" in line:
                parsing_points = True
                continue

            match = list(map(float, re.findall(r"[-+]?\d*\.?\d+", line)))  # Convert to list of floats

            if parsing_points:
                if len(match) == 2:  # Ensure it's a valid point (x, y)
                    points.append(tuple(match))
            else:
                rectangle.extend(match)  # Store all rectangle coordinates as a flat list

        # Convert rectangle from a flat list to a list of (x, y) tuples
        if len(rectangle) == 8:
            rectangle = [(rectangle[i], rectangle[i + 1]) for i in range(0, 8, 2)]
        else:
            raise ValueError(f"Invalid rectangle data: {rectangle}")  # Error if incorrect

        return rectangle, points

    @keyword('Parse the output text file')
    def parse_output_file(self, filename):
        """Reads the visited points from the output file."""
        with open(filename, "r") as file:
            lines = file.readlines()

        actual_points = []
        for line in lines:
            match = re.findall(r"[-+]?\d*\.?\d+", line)
            if match:
                actual_points.append(tuple(map(float, match)))
            elif "error" in line.lower():
                actual_points.append("error")
            else:
                actual_points.append(())

        return actual_points

    @keyword
    def is_within_rectangle(self, point, rectangle):
        """Checks if a point is inside the given rectangle bounds."""
        if len(rectangle) < 4:
            print("Error: Rectangle data is incomplete. Cannot check point boundaries.")
            return False  # Default to out-of-bounds
        x_min = min(rectangle[0][0], rectangle[2][0])
        x_max = max(rectangle[0][0], rectangle[2][0])
        y_min = min(rectangle[0][1], rectangle[1][1])
        y_max = max(rectangle[0][1], rectangle[1][1])

        return x_min <= point[0] <= x_max and y_min <= point[1] <= y_max

    @keyword('Validate Points')
    def validate_points(self, expected_points, actual_points, rectangle):
        """Validates that the visited points match the expected and stay within the rectangle."""
        results = []
        pass_criteria = True

        max_len = max(len(expected_points), len(actual_points))  # Handle different lengths

        for i in range(max_len):
            exp = expected_points[i] if i < len(expected_points) else "MISSING"
            act = actual_points[i] if i < len(actual_points) else "EXTRA"
            if act == "error":
                results.append(f"{exp}\t\t{act}\t\tFAIL (System error)")
                pass_criteria = False
            elif act == ():
                results.append(f"{exp}\t\t{act}\t\tFAIL (System error)")
                pass_criteria = False
            elif act == "EXTRA":
                results.append(f"{exp}\t\t{act}\t\tFAIL (Extra unexpected point)")
                pass_criteria = False
            elif exp == "MISSING":
                results.append(f"{exp}\t\t{act}\t\tFAIL (Missing expected point)")
                pass_criteria = False
            elif not self.is_within_rectangle(act, rectangle):
                results.append(f"{exp}\t\t{act}\t\tFAIL (Out of bounds)")
                pass_criteria = False
            elif exp != act:
                results.append(f"{exp}\t\t{act}\t\tFAIL (Unexpected point)")
                pass_criteria = False
            else:
                results.append(f"{exp}\t\t{act}\t\tPASS")

        result_status = "PASS" if pass_criteria else "FAIL"
        return {"result": result_status, "details": results}

    @keyword('Log Result to Text File')
    def log_results_to_file(self, results, tcName):
        """Writes the validation results to a file.
        :param results:
        :param TCName:
        """
        RESULT_FILE = "Reports/test_results_" + tcName + ".txt"
        with open(RESULT_FILE, "w") as file:
            file.write("Expected visited points\t\tActual visited points\t\tTest result\n")
            file.write("\n".join(results["details"]))

        if results["result"] == "FAIL":
            print("Test FAILED. Check test_results_" + tcName + ".txt for details in Reports folder.")
        else:
            print("Test PASSED.")

    @keyword
    def get_data_from_input_sheet(self, TCName, inputPath):
        # inputPath=  r"../Resource/NAM/InputData.xlsx"
        inputdict = {}
        try:
            df_tclist = pd.read_excel(inputPath, engine='openpyxl', dtype=object)
            df_tclist.fillna('Nil', inplace=True)
            out_frame = pd.DataFrame(df_tclist)
            inputData = out_frame.to_dict('index')

            for i in inputData.items():
                if i[1]['TCName'] == TCName:
                    inputdict = i[1]
            if inputdict == {}:
                raise Exception("Failed in Fetching the data from input sheet")
        except Exception as e:
            raise Exception("Failed in Fetching the data from input sheet")
        return inputdict

    @keyword
    def page_should_have_image(self, filename, similarity=0.8):
        time.sleep(1)
        similarity = float(similarity)
        self.selLib.driver.save_screenshot('./Screenshots/image.png')
        image = cv2.imread('./Screenshots/image.png')
        # image = cv2.imread('.Screenshots/Screenshots/image.png')
        template = cv2.imread(filename)
        result = cv2.matchTemplate(image, template, cv2.TM_CCOEFF_NORMED)
        min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)
        assert max_val >= similarity, \
            'Template not found ({} < {})'.format(max_val, similarity)
        return (int(max_loc[0] + template.shape[1] / 2),
                int(max_loc[1] + template.shape[0] / 2))

    @keyword
    def click_on_image(self, filename, similarity=0.8):
        x, y = self.page_should_have_image(filename, similarity)

        el = self.selLib.driver.execute_script(
            'return document.elementFromPoint({}, {});'.format(x, y))
        el.click()
