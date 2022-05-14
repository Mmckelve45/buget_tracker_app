import time
import os.path

# Commands that the command text file can have 
commands = ['SAVE', 'LOAD']

# Object that will hold the save data 
class Deal:
    def __init__(self, title, value, discount, priceAfter):
        self.title = title
        self.value = value 
        self.discount = discount
        self.priceAfter = priceAfter

# The save function 
def Save(filename):
    # Open the files 
    # contents = open('./lib/microservice/contents.txt', 'r+')
    contents = open('C:/Users/Matthew McKelvey/Downloads/contents.txt', 'r+')
    # "C:\Users\Matthew McKelvey\Downloads\Checking_Checking_Transactions_20220513-175611.CSV"
    savefile = open(filename, 'r+')
    # Hold the save data in a struct 
    deals = []
    
    

    # Loop through the contents assigning data to struct then appending list
    while(True):
        # Save the title
        title = contents.readline().strip('\n')

        # Get rid of last newline 
        x = contents.readline().strip('\n')
        # End of string; do nothing 
        if(x == ''):
            break
        # Split spaces 
        t_obj = x.split()
        # Store the data into the struct object 
        t_deal = Deal(title, t_obj[0], t_obj[1], t_obj[2])
        # Append the list 
        deals.append(t_deal)
    
    # Save these contents into the save file (This can be done in a number of ways)
    savefile.truncate()
    for x in deals: 
        # Combine string and write the line into the save file 
        line = x.title + "\n" + x.value + " " + x.discount + " " + x.priceAfter + "\n"
        savefile.write(line)

    # Close files 
    contents.close()
    savefile.close()

def Load(filename):
    # Open the files 
    # contents = open('./lib/microservice/contents.txt', 'r+')
    while not os.path.exists('C:/Users/Matthew McKelvey/Downloads/contents.txt'):
        time.sleep(1)
    
    if os.path.isfile('C:/Users/Matthew McKelvey/Downloads/contents.txt'):
        contents = open('C:/Users/Matthew McKelvey/Downloads/contents.txt', 'r+')
        savefile = open(filename, 'r+')
    # Hold the save data in a struct 
    deals = []

    # Loop through the contents assigning data to struct then appending list
    while(True):
        # Save the title
        title = savefile.readline().strip('\n')
        
        # Get rid of last newline 
        x = savefile.readline().strip('\n')
        # End of string; do nothing 
        if(x == ''):
            break
        # Split spaces 
        t_obj = x.split()
        print(t_obj)
        # Store the data into the struct object 
        t_deal = Deal(title, t_obj[0], t_obj[1], t_obj[2])
        # Append the list 
        deals.append(t_deal)
    
    contents.truncate()
    for x in deals: 
        # Combine string and write the line into the save file 
        line = x.title + "\n" + x.value + " " + x.discount + " " + x.priceAfter + "\n"
        contents.write(line)
    
    # Close 
    contents.close()
    savefile.close()


#---------Below is the driver code running an infinite loop on the command.txt script--------# 

print("Running Save System!...")

# Loop infinite 
while(True):
    time.sleep(1)
    # File descriptor 
    # f = open("./lib/microservice/command.txt", 'r+')
    while not os.path.exists('C:/Users/Matthew McKelvey/Downloads/command.txt'):
        time.sleep(1)
    if os.path.isfile('C:/Users/Matthew McKelvey/Downloads/command.txt'):    
        f = open('C:/Users/Matthew McKelvey/Downloads/command.txt', 'r+')
    # Read the first line of the command text  
    x = f.readline().strip('\n')
    # If empty just relax for a moment 
    if(x == '' or x == 'DONE'):
        time.sleep(2)
        f.seek(0)
        continue
    # Split the command into 2
    cmd = x.split()
    # Carry out the task 
    if(cmd[0] == commands[0]):
        Save("./lib/microservice/" + cmd[1])
    elif(cmd[0] == commands[1]):
        Load("./lib/microservice/" + cmd[1]) 
    else:
        print("Uhh something went wrong with the commands!")   
        exit()
    # Notify Completion
    f.seek(0)
    f.truncate()
    f.write("DONE")

