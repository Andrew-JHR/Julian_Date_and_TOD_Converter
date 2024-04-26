from tkinter import *
from datetime import datetime
from datetime import date

y4mmdd = date.today().strftime("%Y%m%d")
yyjjj  = date.today().strftime("%y%j")

input1 = date.today().strftime("%Y%m%d")
tmstr = ''

def press():
    input1 = ent1.get()
    if len(input1) == 8:
       try:
         tmobj1 = datetime.strptime(input1,"%Y%m%d")
         tmstr = tmobj1.strftime("%y%j")
       except:  
         tk1 = Tk()
         msg = Message(tk1, text = 'Gregrorian date value invalid!')
         msg.config(bg = 'yellow', font =('times',20,'italic'))
         msg.pack(fill=BOTH,expand=YES)
       else:  
         ent2.delete(1.0,END)
         ent2.insert(END,tmstr)
    elif len(input1) == 5:
       try:
         tmobj2 = datetime.strptime(input1,"%y%j")
         tmstr = tmobj2.strftime("%Y%m%d")
       except:  
         tk2 = Tk()
         msg = Message(tk2, text = 'Julian date value invalid!')
         msg.config(bg = 'yellow', font =('times',20,'italic'))
         msg.pack(fill=BOTH,expand=YES)
       else:  
         ent2.delete(1.0,END)
         ent2.insert(END,tmstr) 
    else:          
       tk3 = Tk()
       msg = Message(tk3, text = 'Not an acceptable value!')
       msg.config(bg = 'yellow', font =('times',20,'italic'))
       msg.pack(fill=BOTH,expand=YES)

tk = Tk()
tk.title('AJ')
tk.iconbitmap('d:/python/andrew2.ico')
tk.geometry("200x150")
lbl1 = Label(tk)
lbl1.config(text='From: e.g. ' + y4mmdd + ' or ' + yyjjj)
lbl1.pack(side=TOP)
ent1 = Entry(tk,width = 15,bg = "light yellow")
ent1.insert(0, input1)
ent1.config(font=('times',16))
ent1.pack(side=TOP)
lbl2 = Label(tk)
lbl2.config(text='To:                                              ')
lbl2.pack(side=TOP)
ent2 = Text(tk,height = 1,width = 15,bg = "light cyan")
ent2.config(font=('times',16))
ent2.pack(side=TOP)
ent2.bind('<Return>', (lambda event: press()))
lbl3 = Label(tk)
lbl3.config(text='   ')
lbl3.pack(side=TOP)
btn = Button(tk, text = 'Convert',width = 23, command = press)
btn.pack(side=TOP)

tk.mainloop()








