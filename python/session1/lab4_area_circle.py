"""Write a Python program which accepts the radius of a circle and compute the area."""
import math


def area(number1):
    """Calculate the area of a circle given its radius.
    
    Args:
        number1 (float): The radius of the circle.
    
    Returns:
        float: The area of the circle.
    """
    return math.pi * number1 ** 2

if __name__ == "__main__":
    assert area(2) == 12.566370614359172, "Test case failed"
    assert area(1) == 3.141592653589793, "Test case failed"
    assert area(0) == 0.0, "Test case failed"
    assert area(5) == 78.53981633974483, "Test case failed"
