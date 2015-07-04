#CLI_create_menu.pm
package CLI_create_menu;
use warnings;
use strict;

use Exporter;
our @ISA = "Exporter";
our @EXPORT_OK = qw(create_cli_menu);

use lib("/home/kevinkabatra/Documents/perl_cli_creator/cli_creator_modules");
use Resize_screen qw(resize_screen);
use Clear_screen  qw(clear_screen);

#/**
# * Creates a tabbed menu system using ASCII characters.
# * 
# * Currently forcing the terminal screen to be a width of 144 char, and height of 31 char.
# * Using these dimensions, each line of the screen will be able to display 140 characters,
# * when compensating for trailing '|' for the borders and ' ' one block of whitespace between
# * the text and the borders.
# * 
# * This can be used independently, but it has been designed to be used in conjuction with CLI.pm.
# * 
# * Example code:
# * create_cli_menu(\@menu_items, $menu_chosen);
# * 
# * parameters: Array as reference, will contain the text for @menu_items.
# * 		String as scalar, will contain the name of the chosen menu. (OPTIONAL)
# */
sub create_cli_menu($;$) {
	#Declare variables
	my @menu_items = @{shift()};
	my $menu_chosen = "";
	$menu_chosen = shift if @_;

	my $screen_width = 144;
	my $screen_height = 31;	

	#Setup terminal
	clear_screen;
	resize_screen($screen_height, $screen_width);
	
	my $__draw_screen_top = sub {
		print " ";
		for(3..$_[0]) {
			print "_"; #top border
		}
		print " ";
	};
	$__draw_screen_top->($screen_width);

	my $__draw_menu_items = sub {
		print "|"; #left border
		my $menu_length = 3 * scalar @menu_items; #2 whitespace + 1 seperator
		for(@menu_items) {
			$menu_length += length($_);
			print " $_ |"; #menu item & menu seperator
		}
		for(1..(142 - $menu_length)) {
			print " "; #white space after menus
		}
		print "|", "\n"; #right border
	};
	$__draw_menu_items->(@menu_items);

	my $__draw_menu_bottom = sub {
		print "|"; #left border
		if($menu_chosen eq "") {
			for(1..142) {
				print "="; #bottom border
			}
		} else {
			#Find where chosen menu item is in array
			my $menu_chosen_place_in_array = 0;
			for(@menu_items) {
				if($menu_chosen eq $_) {
					last;
				} else {
					$menu_chosen_place_in_array++;
				}
			}

			#Find where the chosen menu item's tab begins
			my $menu_length_til_menu_chosen = 3 * $menu_chosen_place_in_array;
			for(0..($menu_chosen_place_in_array - 1)) {
				$menu_length_til_menu_chosen +=
						length($menu_items[$_]);
			}

			#Make menu border until the beginning of the chosen tab
			for(1..$menu_length_til_menu_chosen) {
				print "=";
			}
			
			#Find where the chose menu item's tab ends
			my $tab_length = length($menu_items[$menu_chosen_place_in_array]) + 2;
			for(1..$tab_length) {
				print " ";
			}
		
			#Finish the remainder of the menu border
			for(1..(142 - $tab_length - $menu_length_til_menu_chosen)) {
				print "=";
			}
		}	
		print "|"; #right border
		print "\n";
	};
	$__draw_menu_bottom->();
}

1;
