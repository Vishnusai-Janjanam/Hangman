#!/usr/local/bin/perl

sub getChoice(){		# To get the choice for text or graphic version.
	print "Enter 0 for Simple text version of hangman and 1 for graphic version: ";
	$choice = int(<STDIN>);
	if($choice !=0 && $choice != 1) {	# Checking invalid choice.
		$choice = -1;
	}
	return $choice;
}

sub getStringFromFile(){ 			# To get a random word form the data.txt file.
	open ( $fh, "<", "data.txt" );
	open ( $fh1, "<", "data.txt" );
	$line = "";
	$cnt =0;
	while($line = <$fh1>){					# Counts the number of lines in a file.
		$cnt++;
	}
	close($fh1);
	$randno = int(rand($cnt))+1;			# selecting a random number;
	while( $randno>0){
		$line = <$fh>;
		$randno  = $randno -1;
	}
	$line =~ s/\s+$//;								# To remove tralling whitespaces like space and tab.
	chomp($line);										# Removing traling newline if present.
	$line = uc $line;
	close($fh);
	return $line;
}

sub printHangman(){					# Prints the current state of Hangman
	print @Hp1;
	print @Hp2;
	print @Hp3;
	print @Hp4;
	print @Hp5;
	print @Hp6;
	print @Hp7;
	print @Hp8;
}	
sub getGuess(){						# Gets a guess from the user.
	print "Your guess: ";
	$c = <STDIN>;
	chomp($c);
	return $c;
}
sub makeGuess(){		# promtes user to give his/her guess and checks it.

	print "Word: ";				# Printing the current state of the
	print @userString;
	print "\n";
	$tuserGuess = "!";
	$check = 0;

	while($check ==0){
		while($tuserGuess !~ /[a-zA-Z0-9]/){ #using regex to check a valid input.
			$tuserGuess = getGuess();	
		}
		$tuserGuess = uc $tuserGuess;
		$flag =0;
		foreach  (@GuessesSoFar){ 		# Checking if the letter is already guessed.
			if($_ eq $tuserGuess) {
				$flag = 1;
			}
		}
		if($flag == 0) {
			$check = 1;
		}
		else{
			print "$tuserGuess is already guessed!\n";
			$tuserGuess = "!";
		}
	}
	return $tuserGuess;
}
sub checkMiss(){		# to check if the letter is in the word or not, also updating if present. 
	$ck = 1;
	$temp = $userGuess;
	for($i=0;$i<$len;$i++){
		if($ans[$i] eq $userGuess){			# Updating the positions where the guessed letter is present.
			$ck = 0;
			$userString[$i] = $temp;
		}
	}
	return $ck;
}

sub makeHangman(){            # makes the initial hangman.
	@Hp1 = (' ',' ','-','-','-','-','-','-',"\n");
	@Hp2 = (' ',' ','|',' ',' ',' ',' ','|', "\n");
	@Hp3 = (' ',' ','|',' ',' ',' ',' ',' ',' ',"\n");
	@Hp4 = (' ',' ','|',' ',' ',' ',' ',' ',' ',' ',"\n");
	@Hp5 = (' ',' ','|',' ',' ',' ',' ',' ',' ',"\n");
	@Hp6 = (' ',' ','|',' ',' ',' ',' ',' ',' ',' ',"\n");
	@Hp7 = (' ',' ','|',' ',' ',' ',' ',' ',' ',' ',"\n");
	@Hp8 = (' ','-','-','-',"\n");
}
sub updateHangman(){			# Changes hagman if there is a miss.
	if($guess == 6){			# Adds head to the hangman
		$Hp3[7] = 'O'; 
	}
	elsif($guess == 5){  # Adds middle  body.
		$Hp4[7] = '|';
		$Hp5[7] = '|';
	}
	elsif($guess == 4){		# Adds left hand.
		$Hp4[6] = '\\';
	}
	elsif($guess == 3){		# Adds right hand
		$Hp4[8] = '/';
	}
	elsif($guess == 2){   # Adds left leg
		$Hp6[6] = '/';
	}
	else {								# Adds right leg
		$Hp6[8] = '\\';    
	}
	$guess--;
}
sub printResult(){					# Prints the final result of the game.
	if($won == 1){
		print "You Won!! \n\n";
		print @ans;
		print " is the correct word\n\n";
	}
	else {
		print "You lost! \n\n";
		print "The correct word is: ";
		print @ans;
		print "\n\n";
	}
}

sub ckWin(){				# checks if the player has won.
	$ck = 1;
	for($i = 0; $i<$len;$i++){
		if($ans[$i] ne $userString[$i]){
			$ck = 0;
		}
	}
	return $ck;
}
sub main(){
	$choice  = -1;
	while($choice ==-1) {
		$choice = getChoice();		# getting a valid choice form user.
	}
	$guess = 6;
	$tans = getStringFromFile();		# Gets a random word form the file
	@ans = split // ,"$tans";
	$len = length($tans);
	$tuserString = "-" x $len;
	@userString = ();
	for($i=0;$i<$len;$i++){
		push @userString ,'-';
	}
	$won = 0;
	print "\033[2J";    	# Clears the screen.
	print "\033[0;0H"; 

	makeHangman();			#makes the initial hangman

	@GusesesSoFar = ();

	while($guess >0 && $won ==0){
		if($choice == 1){
			printHangman();
		}
		print "Guesses So Far: "; #prints guesses so far
		print @GuessesSoFar;
		print "\n";
		$userGuess = makeGuess(); #getting valid guess from the user
		push @GuessesSoFar , "$userGuess" ; # updatig already guessed array.
		$miss  = checkMiss();
		if($miss ==1 && $choice ==1){
			updateHangman();			#updating hangman in case of miss in graphic version.
		}
		elsif($choice == 0){		# case of text version
			$t = "Good guess!";
			if($miss ==1) {
				$t= "Bad guess!";
				$guess--;
			}
			print "$t you have $guess parts left. \n\n";
		}
			$won = ckWin(); # checking if the player has won.
	}
	if($choice == 1){
		printHangman();
	}
	printResult();  #printing the result.
}

main();