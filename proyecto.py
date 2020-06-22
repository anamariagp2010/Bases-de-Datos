from tkinter import *
from tkinter import ttk
import tkinter as tk

def saveLeer():
    #Vuelve al Menu principal
    main()

def saveElim():
    numDocElim = int(numDocElimTxt.get())
    #Vuelve al Menu principal
    main()
    
def saveReg():
    #Datos Registro:
    ciudad = comboCiudad.get()
    rango = comboRango.get()
    sexoTmp = comboSexo.get()
    tipoDoc = comboTipoDoc.get()
    numDoc = int(numDocTxt.get())
    nombre = nombreTxt.get()
    apellido = apellidoTxt.get()
    direc = direcTxt.get()
    fechaNac = fechaNacTxt.get()
    tel = int(telTxt.get())
    ocup = ocupTxt.get()
    correo = correoTxt.get()
    if(sexoTmp == "Femenino"):sexo = 1
    else:sexo = 0
    #Vuelve al Menu principal
    main()
    
def registrar():
    #registra si el cliente no existe, de lo contrario actualiza
    global comboCiudad,comboRango,numDocTxt,nombreTxt,apellidoTxt,direcTxt,fechaNacTxt,comboSexo,telTxt,ocupTxt,correoTxt,comboTipoDoc
    lbl.configure(text="Registro o Actualizacion de Clientes")
    reg.place_forget()
    act.place_forget()
    read.place_forget()
    elim.place_forget()
    back = Button(window, text="Guardar y Regresar", bg='LightGreen', command=saveReg)
    back.place(x=800,y=550)
    #Datos de estaticos:
    ciudades = ["Cali","Bogota","Medellin","Cartagena"]
    rangos = ["0-1.000.000","1.000.001-2.000.000","mas de 2.000.000"]
    tipoDocs = ["CC","TI"]
    sexos = ["Femenino","Masculino"]

    #Combobox: 
    comboCiudad = ttk.Combobox(window)
    comboCiudad['values']= ciudades
    comboCiudad.place(x=200,y=480)
    comboRango = ttk.Combobox(window)
    comboRango['values']= rangos
    comboRango.place(x=200,y=440)
    comboSexo = ttk.Combobox(window)
    comboSexo['values']= sexos
    comboSexo.place(x=200,y=320)
    comboTipoDoc = ttk.Combobox(window)
    comboTipoDoc['values']= tipoDocs
    comboTipoDoc.place(x=200,y=80)

    #Textos: 
    TD = Label(window, text="Tipo de documento")
    TD.place(x=50,y=80)
    ND = Label(window, text="Numero de documento")
    ND.place(x=50,y=120)
    NOM = Label(window, text="Nombres")
    NOM.place(x=50,y=160)
    APE = Label(window, text="Apellidos")
    APE.place(x=50,y=200)
    DIR = Label(window, text="Direccion")
    DIR.place(x=50,y=240)
    FEC = Label(window, text="Fecha de Nacimiento")
    FEC.place(x=50,y=280)
    SEX = Label(window, text="Sexo")
    SEX.place(x=50,y=320)
    TLF = Label(window, text="Telefono")
    TLF.place(x=50,y=360)
    OC = Label(window, text="Ocupacion")
    OC.place(x=50,y=400)
    RS = Label(window, text="Rango Salarial")
    RS.place(x=50,y=440)
    CR = Label(window, text="Ciudad de Residencia")
    CR.place(x=50,y=480)
    CE = Label(window, text="Correo Electronico")
    CE.place(x=50,y=520)

    #Textos    numDocTxt,nombreTxt,apellidoTxt,direcTxt,fechaNacTxt,telTxt,ocupTxt,correoTxt
    numDocTxt = Entry(window,width=20)
    numDocTxt.place(x=200,y=120)
    nombreTxt = Entry(window,width=20)
    nombreTxt.place(x=200,y=160)
    apellidoTxt = Entry(window,width=20)
    apellidoTxt.place(x=200,y=200)
    direcTxt = Entry(window,width=20)
    direcTxt.place(x=200,y=240)
    fechaNacTxt = Entry(window,width=20)
    fechaNacTxt.place(x=200,y=280)
    telTxt = Entry(window,width=20)
    telTxt.place(x=200,y=360)
    ocupTxt = Entry(window,width=20)
    ocupTxt.place(x=200,y=400)
    correoTxt = Entry(window,width=20)
    correoTxt.place(x=200,y=520)

def leer():
    lbl.configure(text="Lista de Clientes")
    reg.place_forget()
    act.place_forget()
    read.place_forget()
    elim.place_forget()
    bac = Button(window, text="Guardar y Regresar", bg='LightGreen', command=saveLeer)
    bac.place(x=800,y=550)

def eliminar():
    global numDocElimTxt
    lbl.configure(text="Eliminar Clientes")
    reg.place_forget()
    act.place_forget()
    read.place_forget()
    elim.place_forget()
    bac = Button(window, text="Guardar y Regresar", bg='LightGreen', command=saveElim)
    bac.place(x=800,y=550)
    #Datos para borrar
    TD = Label(window, text="Ingrese el numero de Documento del cliente que desea eliminar")
    TD.place(x=50,y=80)
    numDocElimTxt = Entry(window,width=20)
    numDocElimTxt.place(x=200,y=120)


def main():
    global lbl,txt,reg,act,read,elim,window,combo
    window = Tk()
    window.geometry('1000x600')
    window.configure(bg = 'Azure')
    window.title('Comunicaciones Colombia S.A.')
    window.resizable(width=False,height=False)
    #Llenar ventana
    lbl = Label(window, text="Bienvenido Al Registro de Usuarios", font=("Arial Bold", 30), bg='Azure')
    lbl.place(x=200,y=30)

    #Que desea hacer?
    reg = Button(window, text="Registrar un nuevo Cliente", bg='LightGreen', command=registrar)
    reg.place(x=450,y=150)
    act = Button(window, text="Actualizar un Cliente", bg='LightGreen', command=registrar)
    act.place(x=470,y=250)
    read = Button(window, text="Leer la lista de Clientes", bg='LightGreen', command=leer)
    read.place(x=465,y=350)
    elim = Button(window, text="Eliminar un Cliente", bg='LightGreen', command=eliminar)
    elim.place(x=470,y=450)
     
    window.mainloop()

main()

