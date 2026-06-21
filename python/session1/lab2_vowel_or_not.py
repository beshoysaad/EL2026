"""Write a Python program to test whether a passed letter is a vowel or not."""

def vowel(letter):
    """Check if a letter is a vowel.

    Args:
        letter (str): A single character.

    Returns:
        bool: True if the letter is a vowel, False otherwise.
    """
    return letter.lower() in "aeiou"


if __name__ == "__main__":
    assert vowel("a"), "Test case failed"
    assert not vowel("b"), "Test case failed"
    assert vowel("A"), "Test case failed"
    assert not vowel("B"), "Test case failed"
    assert vowel("e"), "Test case failed"
    assert vowel("E"), "Test case failed"
    assert vowel("i"), "Test case failed"
    assert vowel("I"), "Test case failed"
    assert vowel("o"), "Test case failed"
    assert vowel("O"), "Test case failed"
    assert vowel("u"), "Test case failed"
    assert vowel("U"), "Test case failed"
    assert not vowel("z"), "Test case failed"
    assert not vowel("Z"), "Test case failed"
