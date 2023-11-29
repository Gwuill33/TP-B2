def filter_lines(input_filename, output_filename, filter_phrase):
    with open(input_filename, 'r') as infile, open(output_filename, 'w') as outfile:
        lines = infile.readlines()
        filtered_lines = []

        i = 0
        while i < len(lines):
            line = lines[i].strip()
            if filter_phrase in line and not line.startswith(('-', '+')):
                # Conserver la ligne juste au-dessus
                if i > 0:
                    filtered_lines.append(lines[i - 1].strip())
                filtered_lines.append(line)
            i += 1

        outfile.write('\n'.join(filtered_lines))

# Utilisation du script
input_file = 'votre_fichier.txt'
output_file = 'resultat_filtre.txt'
filter_phrase = 'Host is up'

filter_lines('result.txt', 'result_filtered_2.txt', 'Host is up')