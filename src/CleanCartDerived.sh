#!/bin/bash

#!inline common.sh

section_separator
echo -e "\n\n🕒 Please be patient. On older computers and virtual machines, this may take 5-10 minutes or longer to run.\n"
echo -e "✅ Cleaning Derived Data files.\n"
rm -rf ~/Library/Developer/Xcode/DerivedData
echo -e "✅ Done Cleaning.\n\n⚠️  If Xcode is open, Quit it and open it again.\n"
exit_message
