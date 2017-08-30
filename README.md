## iOS 11: Apple's NLP vs. server-side NLP

Medium blog post: https://medium.com/huggingface/ios-11-are-apples-new-nlp-capabilities-game-changers-5ab71f706f00

TL;DR: Apple’s on-device NLP gets average accuracy on CoNLL datasets. Out of the box, spaCy (a server-side, Python based NLP framework) consistently gets better precision and recall.

The CoNLL dataset ships with `conlleval`, a Perl script that evaluates a model’s accuracy.

### Disclaimer

Important disclaimer: It is very important to note here, that we evaluate the model on a dataset that is different from the one that trained it. 

NER is a general task, and the CoNLL dataset is designed to be generic enough and close to most use cases, so a good general NER model should perform well on the dataset. However, it’s not completely fair to directly compare F1 scores with those of models that were trained on this data (and only this data). Still, it gives us directionally correct indications.
