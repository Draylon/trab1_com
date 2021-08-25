#ifndef compiler_bytecode_utils
#define compiler_bytecode_utils

#include <string>
#include <map>
#include <set>
#include <vector>

std::string outfileName;
std::vector<std::string> codeList;
typedef enum {E_INT} type_enum;
std::map <std::string, std::pair<int, type_enum>> varToVarIndexAndType;
int currentVariableIndex = 1;
int nextInstructionIndex = 0;
std::vector <std::string> outputCode;
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
	{"%", "rem"},

	/* relational op */
	{"==", "if_icmpeq"},
	{"<=", "if_icmple"},
	{">=", "if_icmpge"},
	{"!=", "if_icmpne"},
	{">",  "if_icmpgt"},
	{"<",  "if_icmplt"}
};


void declareVariable(std::string name, int varType) {
	if (varToVarIndexAndType.count(name) == 1)
		printf("VARIÁVEL JÁ DECLARADA!");
	varToVarIndexAndType[name] = std::make_pair(currentVariableIndex++, static_cast<type_enum>(varType));
}

bool checkIfVariableExists(std::string varName) {
	return varToVarIndexAndType.count(varName);
}

void appendToCode(std::string code) {
	outputCode.push_back("Label_" + std::to_string(nextInstructionIndex) + ":\n" + code);
	nextInstructionIndex++;
}

void backpatch(std::set<int> list, int instruction_index) {
	for (auto index : list) {
		outputCode[index] = outputCode[index].substr(0, outputCode[index].size()-1);
		outputCode[index] += "Label_" + std::to_string(instruction_index);
	}
}

void defineVariable(std::string name, int varType) {
	declareVariable(name, varType);
	if (varType == E_INT) {
		appendToCode("iconst_0");
		appendToCode("istore " + std::to_string(currentVariableIndex -1));
	}
}

void writeCode(std::string x){
	codeList.push_back(x);
}

void createHeader(){
	writeCode(".source " + outfileName);
	writeCode(".class public test\n.super java/lang/Object\n"); //code for defining class
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

void generateFooter()
{
	writeCode("return");
	writeCode(".end method");
}

std::set<int> makeList(int instruction_index) {
	std::set<int> list{instruction_index};
	return list;
}

std::set<int> mergeLists(std::set<int> list1, std::set<int> list2) {
	//As the call is by reference, list1 won't be changed and a its copy will be returned
	list1.insert(list2.begin(), list2.end());
	return list1;
}

std::string getOp(std::string op)
{
	if(inst_list.find(op) != inst_list.end())
	{
		return inst_list[op];
	}
	return "";
}

void arithCast(std::string op)
{
	writeCode("i" + getOp(op));
}




#endif