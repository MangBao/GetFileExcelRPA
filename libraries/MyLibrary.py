from venv import logger
from robot.api.deco import keyword, library

# example of accessing a variable from variables.py
from variables import TODAY

@library
class MyLibrary:
    """Give this library a proper name and document it."""
    @keyword
    def example_python_keyword(self):
        logger.info("This is Python!")
        logger.info(f"... and today is {TODAY}")
