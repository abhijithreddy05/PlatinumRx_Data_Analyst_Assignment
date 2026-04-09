def convert_minutes(minutes):
    """
    Given number of minutes, convert it into human readable form.
    Example:
    130 becomes “2 hrs 10 minutes”
    110 becomes “1hr 50minutes”
    """
    if not isinstance(minutes, int) or minutes < 0:
        return "Invalid input. Please provide a positive integer."
        
    hrs = minutes // 60
    mins = minutes % 60
    
    # Determining pluralization based on example outputs
    hr_str = "hr" if hrs <= 1 else "hrs"
    
    if hrs == 0:
        return f"{mins} minutes"
    elif mins == 0:
        return f"{hrs} {hr_str}"
    else:
        if hrs == 1:
            return f"{hrs}{hr_str} {mins}minutes" # based on "1hr 50minutes" example
        else:
            return f"{hrs} {hr_str} {mins} minutes" # based on "2 hrs 10 minutes" example

if __name__ == "__main__":
    print("Test Cases:")
    test_cases = [130, 110, 60, 45, 0]
    for tc in test_cases:
        print(f'{tc} becomes "{convert_minutes(tc)}"')
