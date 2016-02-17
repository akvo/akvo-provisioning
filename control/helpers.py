__all__ = ["merge_configs"]


def merge_configs(a, b):
    """Non-destructively merge config dictionaries `a` and `b`"""
    config = a.copy()
    config.update(b)
    return config
