extends Node2D


var tips = [
"A codificação contem numeros primos e as letras nao podem se repetir",
"Sequência codifidicada contendo so numeros pares e possui apenas consoantes.",
"Letras em ordem alfabetica com numeros na ordem inversa, sequencial, sem repertir letra ou numero.",
"Sequencia que para cada letra, os numeros nao podem se repetir, apenas numeros pares e depois para cada letra numeros impares, nesses passos. (3 conjuntos de letras e numeros impares e pares)"
]
var code: String = ""
var challenge: int = 1
var attempts: int = 2

func _ready():
	nextChallenge()
	for button in get_tree().get_nodes_in_group("keyboard_group"):
		button.connect("pressed", self, "_button_pressed", [button])
	

func _button_pressed(button):
	if code=="":
		$response_rect/label_reponse.text=""
	if code!="":
		code+="-"
	code+=button.name
	$response_rect/label_reponse.text+=" "+button.name
	print(code)
	
func _on_button_submit_pressed():
	var success: Color= Color("#2ecc71")
#	if challenge==0:
#		if checkFirstRule():
#			$status_1.color = success
#			nextChallenge()			
#		else:
#			testAttempts(1)
#	elif (challenge==1):
#		if checkSecondRule():
#			$status_2.color = success
#			nextChallenge()			
#		else:
#			testAttempts(2)
	if (challenge==2): 
		if checkThirdRule():
			$status_3.color = success
			nextChallenge()			
		else:
			testAttempts(3)
	else: 
		if checkFourthRule():
			$status_4.color = success
			print("terminou")	
		else:
			testAttempts(4)	
	
func testAttempts(status):
	var red :Color = Color("#f22613")
	code = ""
	match status:
		1:
			$status_1.color = red
		2:
			$status_2.color = red
		3:
			$status_3.color = red
		4:
			$status_4.color = red
	if attempts > 1:
		attempts-=1
		$response_rect/label_reponse.text = "Voce tem " + String(attempts) + " tentativa"
	else:
		if challenge!=3:
			nextChallenge()
			
	
func nextChallenge():
	attempts = 2
	code = ""
	challenge+=1
	$response_rect/label_reponse.text="Voce tem " + String(attempts) + " tentativas"
	$label_tip.text = tips[challenge]

func isPrime(num):
	if num> 1:  
		for n in range(2,num):  
			if (num % n) == 0:  
				return false
		return true
	else:
		return false
	
func checkFirstRule():
	var codes = code.split("-")
	print(codes)
	for combination in codes:
		var letter = combination[0]
		var number = int(combination[1])
		if code.count(letter) > 1:
			return false 
		if !isPrime(number):
			return false
	return true
			
func checkSecondRule():
	var codes = code.split("-")
	
	for combination in codes:
		var letter = combination[0]
		var number: int = int(combination[1])
		if letter == "A" or letter == "E":
			return false 
		if number % 2 != 0:
			return false
			
	return true

func isInOrder(arr: Array, type: String):
	var nonSorted = arr
	nonSorted = PoolStringArray(nonSorted).join("")
	arr.sort()
	
	if type =="numeric_inverse":
		arr.invert()
		
	return nonSorted==PoolStringArray(arr).join("")
		
func checkThirdRule():
	var codes = code.split("-")
	var alphaCode = []
	var numberCode = []
	
	for i in codes:
		if code.count(String(i[0])) > 1:
			return false 
		alphaCode.append(String(i[0]))
		numberCode.append(int(i[1]))
	
	if !isInOrder(alphaCode, "alphabet"):
		return false
	if !isInOrder(numberCode, "numeric_inverse"):
		return false
	return true
	
	
func checkFourthRule():
	var codes: Array = code.split("-")
	print(codes.slice(0,2))
	print(codes.slice(3,5))
	
	if codes.size() < 6:
		return false
		
	for combination in codes.slice(0,2):
		var number: int = int(combination[1])
		if number % 2 != 0:
			return false
			
	for combination in codes.slice(3,5):
		var number: int = int(combination[1])
		if number % 2 == 0:
			return false
	return true
	
	
