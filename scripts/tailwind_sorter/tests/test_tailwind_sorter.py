import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../../..")))

from scripts.tailwind_sorter.tailwind_sorter import load_config
from scripts.tailwind_sorter.utils.tailwind import tailwind_sort

config = load_config("scripts/tailwind_sorter/config/default.yml")


def test_tailwind_sorter():
    assert tailwind_sort("rounded my-4 block", config) == "block my-4 rounded"
    assert (
        tailwind_sort("rounded my-4 block nr-class", config)
        == "nr-class block my-4 rounded"
    )
    assert (
        tailwind_sort("sm:block block lg:my-4 my-8", config)
        == "block sm:block my-8 lg:my-4"
    )
    assert (
        tailwind_sort("focus:hover:sm:block my-4", config)
        == "sm:hover:focus:block my-4"
    )
    assert tailwind_sort("block my-4 block", config) == "block my-4"
    assert tailwind_sort("rounded my-4 block", config) == "block my-4 rounded"
    assert (
        tailwind_sort("rounded my-4 block nr-class", config)
        == "nr-class block my-4 rounded"
    )
    assert (
        tailwind_sort("sm:block block lg:my-4 my-8", config)
        == "block sm:block my-8 lg:my-4"
    )
    assert (
        tailwind_sort("focus:hover:sm:block my-4", config)
        == "sm:hover:focus:block my-4"
    )
    assert (
        tailwind_sort("focus:hover:sm:block my-4 nonsense", config)
        == "nonsense sm:hover:focus:block my-4"
    )
