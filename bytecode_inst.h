#ifndef compiler_bytecode_utils
#define compiler_bytecode_utils

#include <string>
#include <map>
#include <vector>

std::string outfileName;
std::vector<std::string> codeList;
typedef enum {E_INT,E_STR,E_CONCAT} type_enum;
std::map<std::string, std::pair<int,type_enum> > lista_simbolos;
int currentVariableIndex = 1;
int nextInstructionIndex = 0;
//std::vector <std::string> codeList;
int variablesNum = 1;
int labelsCount = 0;


/* list of mnemonics that corresponds to specific operators */
std::map<std::string,std::string> inst_list = {
    /* arithmetic operations */
    {"+", "add"},
    {"-", "sub"},
    {"/", "div"},
    {"*", "mul"},
    {"|", "or"},
    {"&", "and"},
    {"or", "or"},
    {"and", "and"},
    {"%", "rem"},

    /* relational op */
    {"==", "if_icmpeq"},
    {"<=", "if_icmple"},
    {">=", "if_icmpge"},
    {"!=", "if_icmpne"},
    {">",  "if_icmpgt"},
    {"<",  "if_icmplt"}
};


bool varExists(std::string varName) {
    return lista_simbolos.count(varName);
}

bool checkId(std::string op){
    return (lista_simbolos.find(op) != lista_simbolos.end());
}

void appendToCode(std::string code) {
    codeList.push_back("L_" + std::to_string(nextInstructionIndex) + ":\n" + code);
    nextInstructionIndex++;
}

void backpatch(std::vector<int> *list, int instruction_index) {
    if(list->size() > 0)
        for (auto it = list->begin(); it != list->end(); ++it) {
            auto index = *it;
            codeList[index] = codeList[index].substr(0, codeList[index].size()-1);
            codeList[index] += " L_" + std::to_string(instruction_index);
        }
}

void writeCode(std::string x){
    codeList.push_back(x);
}

void popCode(int x){
    for(int i=0;i < x;i++){
        codeList.pop_back();
    }
}

void appendCode(int back,std::string x){
    codeList.insert( codeList.begin()+(codeList.size()-back), x );
}

void repositionCode(int back){
    std::string x = codeList.back();
    codeList.pop_back();
    appendCode(back,x);
}

void defineVariable(std::string name, int varType,int autoStore) {
    if (lista_simbolos.count(name) == 1)
        throw std::logic_error("VARIÁVEL JÁ DECLARADA!");
    lista_simbolos[name] = std::make_pair(currentVariableIndex++, static_cast<type_enum>(varType));
    if (varType == E_INT) {
        if(autoStore == 0){
            writeCode("iconst_0");
            writeCode("istore " + std::to_string(currentVariableIndex -1));
        }
    }
}

std::string genLabel(){
    return "L_"+std::to_string(labelsCount++);
}

std::string lastLabel(){
    return "Llllllllllll_"+std::to_string(labelsCount);
}

void createHeader(){
    writeCode(".class public test\n.super java/lang/Object\n"); //code for defining class
    writeCode(".field static private message Ljava/lang/String;");
    writeCode(".method public <init>()V");
    writeCode("aload_0");
    writeCode("invokenonvirtual java/lang/Object/<init>()V");
    writeCode("return");
    writeCode(".end method\n");
    writeCode(".method public static main([Ljava/lang/String;)V");
    writeCode(".limit locals 100\n.limit stack 100");

    /* generate temporal vars for syso
    defineVariable("1syso_int_var",INT_T);
    defineVariable("1syso_float_var",FLOAT_T);*/

    /*generate line*/
    writeCode(".line 1");
}

void createFooter(){
    writeCode("return");
    writeCode(".end method");
}

std::vector<int> makeList(int instruction_index) {
    std::vector<int> list{instruction_index};
    return list;
}

std::vector<int>* merge(std::vector<int> *list1, std::vector<int> *list2) {
    //As the call is by reference, list1 won't be changed and a its copy will be returned
    (*(list1)).insert((*(list1)).begin(),(*(list2)).begin(), (*(list2)).end());
    return list1;
}

std::string getOp(std::string op){
    if(inst_list.find(op) != inst_list.end())
        return inst_list[op];
    return "";
}

void arithCast(std::string op){
    writeCode("i" + getOp(op));
}

void call_converter(int t1,int t2){
    if ((t1 == E_INT || t1 == E_STR) && (t2 == E_INT || t2 == E_STR) ){
        appendCode(2,";concat_start");
        appendCode(2,"getstatic java/lang/System/out Ljava/io/PrintStream;");
        appendCode(2,"new java/lang/StringBuilder");
        appendCode(2,"dup");
        appendCode(2,"invokespecial java/lang/StringBuilder/<init>()V");
        //appendCode(2,"");
        if(t1 == E_INT)
            appendCode(1,"invokevirtual java/lang/StringBuilder/append(I)Ljava/lang/StringBuilder;");
        else
            appendCode(1,"invokevirtual java/lang/StringBuilder/append(Ljava/lang/String;)Ljava/lang/StringBuilder;");
        
        if(t2 == E_INT)
            appendCode(0,"invokevirtual java/lang/StringBuilder/append(I)Ljava/lang/StringBuilder;");
        else
            appendCode(0,"invokevirtual java/lang/StringBuilder/append(Ljava/lang/String;)Ljava/lang/StringBuilder;");

        appendCode(0,"invokevirtual java/lang/StringBuilder/toString()Ljava/lang/String;");
        writeCode("putstatic test/message Ljava/lang/String;");
        //appendCode(0,"invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V");
    }else{
        if(t1 == E_INT || t1 ==  E_STR){
            std::cout << "o t2 já é o concat, tem q colocar o t1 antes do append do t2" << std::endl;
            if(t1 == E_INT)
                appendCode(5,"invokevirtual java/lang/StringBuilder/append(I)Ljava/lang/StringBuilder;");
            else
                appendCode(5,"invokevirtual java/lang/StringBuilder/append(Ljava/lang/String;)Ljava/lang/StringBuilder;");
        }
        if(t2 == E_INT || t2 == E_STR){
            std::cout << "o t1 já fez o concat, entao tem que colocar depois do append do t1" << std::endl;
            repositionCode(2);
            if(t2 == E_INT)
                appendCode(2,"invokevirtual java/lang/StringBuilder/append(I)Ljava/lang/StringBuilder;");
            else
                appendCode(2,"invokevirtual java/lang/StringBuilder/append(Ljava/lang/String;)Ljava/lang/StringBuilder;");
        }
    }
    std::cout << "not implemented :sadge: :mikewazolski:" <<std::endl;
}



#endif