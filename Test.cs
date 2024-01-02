using Godot;
using System;

public partial class Test : Control
{
    public override void _Ready()
    {
        base._Ready();
        GD.Print("Test");

        var symSpell = new SymSpell(82765, 2);
        string baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
        string dictionaryPath = "frequency_dictionary_en_82_765.txt";
        int termIndex = 0; //column of the term in the dictionary text file
        int countIndex = 1; //column of the term frequency in the dictionary text file
        if (!symSpell.LoadDictionary(dictionaryPath, termIndex, countIndex))
        {
            GD.Print("File not found!");
            //press any key to exit program
            // Console.ReadKey();
            return;
        }


        string word = "tis is a tset. wehre si my fther?";
        int maxEditDistanceLookup = 2;
        var suggestionVerbosity = SymSpell.Verbosity.Closest;
        var suggestions = symSpell.LookupCompound(word, maxEditDistanceLookup);

        foreach (var suggestion in suggestions)
        {
            GD.Print(suggestion.term, suggestion.distance.ToString(), suggestion.count.ToString());
        }


    }
}
