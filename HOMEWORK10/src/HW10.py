import random
def guess_number():
    correct_number = random.randint(1, 100)
    max_tries = 5

    print(f"Guess a number between 1 to 100. You have {max_tries} attempts.")
    
    for tries in range(max_tries):
        try:
            guess = int(input(f"Your try {tries + 1}: Enter you number: "))
            if guess == correct_number:
                print("Congratulatios! You guessed the correct number.")
                return
            elif guess < correct_number:
                print("Too low.")
            else:
                print("Too high.")
        except ValueError:
            print("Please enter a valid number.")
    print(f"Sorry, you're out of attempts. The correct number {correct_number}.")
guess_number()