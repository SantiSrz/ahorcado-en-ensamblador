NAME = Caracter

all: $(NAME)

$(NAME): $(NAME).o
	ld -m elf_i386 $(NAME).o -o $(NAME)

$(NAME).o: $(NAME).asm
	nasm -f elf32 $(NAME).asm -o $(NAME).o

clean:
	rm -f $(NAME) $(NAME).o

run: all
	./$(NAME)