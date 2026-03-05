import os
from dotenv import load_dotenv

load_dotenv()

LEETCODE_GRAPHQL_URL = os.getenv(
    "LEETCODE_GRAPHQL_URL",
    "https://leetcode.com/graphql"
)
