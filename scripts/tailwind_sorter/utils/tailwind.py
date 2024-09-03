from typing import Dict, List, Tuple


def get_class_order(class_name: str, config: Dict) -> int:
    for group_index, (group, classes) in enumerate(config["classes_order"].items()):
        if class_name in classes:
            return group_index
    return -1  # Unknown classes


def get_variant_order(variant: str, config: Dict) -> int:
    return (
        config["variants_order"].index(variant)
        if variant in config["variants_order"]
        else len(config["variants_order"])
    )


def split_variants(class_name: str) -> Tuple[List[str], str]:
    parts = class_name.split(":")
    return parts[:-1], parts[-1]


def sort_variants(variants: List[str], config: Dict) -> List[str]:
    return sorted(variants, key=lambda v: get_variant_order(v, config))


def tailwind_sort(class_string: str, config: Dict) -> str:
    classes = class_string.split()

    # remove duplicates
    classes = list(dict.fromkeys(classes))

    # group classes by their order
    grouped_classes: Dict[int, List[Tuple[List[str], str]]] = {}
    for cls in classes:
        variants, base_class = split_variants(cls)
        order = get_class_order(base_class, config)
        if order not in grouped_classes:
            grouped_classes[order] = []
        grouped_classes[order].append((variants, base_class))

    # gort classes within each group and flatten the result
    result = []
    for order in sorted(grouped_classes.keys()):
        sorted_group = sorted(
            grouped_classes[order],
            key=lambda x: (
                [get_variant_order(v, config) for v in sort_variants(x[0], config)],
                x[1],  # Sort by base class name if variant order is the same
            ),
        )
        result.extend(
            [
                ":".join(sort_variants(variants, config) + [base_class])
                for variants, base_class in sorted_group
            ]
        )

    return " ".join(result)
