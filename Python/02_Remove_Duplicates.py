def remove_duplicates(input_string):
    """
    Given a string, remove all the duplicates and print the unique string.
    Use loop in the python.
    """
    unique_string = ""
    for char in input_string:
        if char not in unique_string:
            unique_string += char
            
    return unique_string

if __name__ == "__main__":
    print("Test Cases:")
    test_cases = ["hello world", "programming", "aabbccddeeff", "python"]
    for tc in test_cases:
        result = remove_duplicates(tc)
        print(f'"{tc}" becomes "{result}"')
