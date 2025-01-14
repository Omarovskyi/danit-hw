class Alphabet:
    def __init__(self, lang, letters):
        self.lang = lang
        self.letters = letters

    def print(self):
        print("Alphabet letters:", ''.join(self.letters))

    def letters_num(self):
        return len(self.letters)
        
class EngAlphabet(Alphabet):
    _letters_num = 26

    def __init__(self):
        super().__init__('En', list('ABCDEFGHIJKLMNOPQRSTUVWXYZ'))

    def is_en_letter(self, letter):
        return letter in self.letters
    
    def letters_num(self):
        return self._letters_num
    
    @staticmethod
    def example():
        return "This is an example text in English."
    
if __name__ == "__main__":
    eng_alphabet = EngAlphabet()

    eng_alphabet.print()

    print("Number of letters in the English alphabet:", eng_alphabet.letters_num())

    print("Does 'F' belong to the English alphabet?", eng_alphabet.is_en_letter('F'))

    print("Does 'Щ' belong to the English alphabet?", eng_alphabet.is_en_letter('Щ'))

    print("Example text:", EngAlphabet.example())