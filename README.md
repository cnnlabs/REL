# REL: Radboud Entity Linker

![API status](https://img.shields.io/endpoint?label=status&url=https%3A%2F%2Frel.cs.ru.nl%2Fapi)
![build](https://github.com/cnnlabs/REL/workflows/build/badge.svg)

**NOTE:** This repo was forked from [informagi/REL](https://github.com/informagi/REL)

REL is a modular Entity Linking package that is provided as a Python package as well as a web API. REL has various meanings -  one might first notice that it stands for relation, which is a suiting name for the problems that can be tackled with this package. Additionally, in Dutch a 'rel' means a disturbance of the public order, which is exactly what we aim to achieve with the release of this package.

REL utilizes *English* Wikipedia as a knowledge base and can be used for the following tasks:
- **Entity linking (EL)**: Given a text, the system outputs a list of mention-entity pairs, where each mention is a n-gram from text and each entity is an entity in the knowledge base.
- **Entity Disambiguation (ED)**: Given a text and a list of mentions, the system assigns an entity (or NIL) to each mention.

# Setup API
This section elaborates on how a user may utilize our API. Steps include obtaining an API key and querying our API.

### Obtaining a key
At the moment we do not require obtaining a key; please continue to the next step.

### Querying our API
Users may access our API by using the example script below.
For EL, the `spans` field is not required. For ED, however, the `spans` field should consist of a list of tuples, where each tuple refers to the start position and length of a mention.

```python
import requests

IP_ADDRESS = "https://rel.cs.ru.nl/api"
text_doc = "If you're going to try, go all the way - Charles Bukowski"

# Example EL.
document = {
    "text": text_doc,
}

# Example ED.
document = {
    "text": text_doc,
    "spans": [(41, 16)]
}


API_result = requests.post("{}".format(IP_ADDRESS), json=document).json()
```

# Setup package
This section describes how to deploy REL on a local machine and setup the API. If you want to do anything more than simply running our API locally, you can skip the Docker steps and continue with installation from source.

## Installation using Docker
### Prebuilt images
To use our prebuilt default images, run:
```bash
# Pull the image for Wikipedia 2014:
docker pull informagi/rel:2014
# Or Wikipedia 2019:
docker pull informagi/rel:2019
```

To run the API locally:
```bash
# Map container port 5555 to local port 5555, and use Wikipedia 2019
docker run -p 5555:5555 --rm -it informagi/rel:2019
# Or automatically generate port mapping
docker run -P --rm -it informagi/rel:2019
```

Now you can make requests to `http://localhost:5555` (or another port if you
use a different mapping) in the format described in the example above.

### Build your own
To build the Docker image yourself, run:
```bash
# Clone the repository
git clone https://github.com/informagi/REL && cd REL
# Build the Docker image
docker build - -t informagi/rel < Dockerfile
```
The build process will automatically download all necessary files. Wikipedia
version 2019 is used by default - to specify the Wikipedia version (either 2019
or 2014), pass e.g. `--build-arg WIKI_YEAR=2014` to the `docker build`
command:

```bash
docker build - -t informagi/rel --build-arg WIKI_YEAR=2014 < Dockerfile
```

To run the API locally, use the same commands as mentioned in the previous section.

## Installation from source
Run the following command in a terminal to install REL:
```
pip install git+https://github.com/informagi/REL
```
You will also need to manually download the files described in the next section.

## Download
The files used for this project can be divided into three categories. The first is a generic set of documents and embeddings that was used throughout the project. This folder includes the GloVe embeddings used by Le et al. and the unprocessed datasets that were used to train
the ED model. The second and third category are Wikipedia corpus related files, which in our case either originate from a 2014 or
2019 corpus. Alternatively, users may use their own corpus, for which we refer to the tutorials.

[Download generic files](http://gem.cs.ru.nl/generic.tar.gz)

[Download Wikipedia corpus (2014)](http://gem.cs.ru.nl/wiki_2014.tar.gz)

[Download ED model 2014](http://gem.cs.ru.nl/ed-wiki-2014.tar.gz)

[Download Wikipedia corpus (2019)](http://gem.cs.ru.nl/wiki_2019.tar.gz)

[Download ED model 2019](http://gem.cs.ru.nl/ed-wiki-2019.tar.gz)

## Tutorials
To promote usage of this package we developed various tutorials. If you simply want to use our API, then
we refer to the section above. If you feel one is missing or unclear, then please create an issue, which is much appreciated :)! The first two tutorials are
for users who simply want to use our package for EL/ED and will be using the data files that we provide.
The remainder of the tutorials are optional and for users who wish to e.g. train their own Embeddings.

1. [How to get started (project folder and structure).](https://github.com/informagi/REL/tree/master/tutorials/01_How_to_get_started.md)
2. [End-to-End Entity Linking.](https://github.com/informagi/REL/tree/master/tutorials/02_E2E_Entity_Linking.md)
3. [Evaluate on GERBIL.](https://github.com/informagi/REL/tree/master/tutorials/03_Evaluate_Gerbil.md)
4. [Deploy REL for a new Wikipedia corpus](https://github.com/informagi/REL/tree/master/tutorials/deploy_REL_new_Wiki/04_deploy_REL_new_wiki.md):
    1. [Extracting a new Wikipedia corpus and creating a p(e|m) index.](https://github.com/informagi/REL/tree/master/tutorials/deploy_REL_new_Wiki/04_01_Extracting_a_new_Wikipedia_corpus.md)
    2. [Training your own Embeddings.](https://github.com/informagi/REL/tree/master/tutorials/deploy_REL_new_Wiki/04_02_training_your_own_embeddings.md)
    3. [Generating training, validation and test files.](https://github.com/informagi/REL/tree/master/tutorials/deploy_REL_new_Wiki/04_03_generating_training_test_files.md)
    4. [Training your own Entity Disambiguation model.](https://github.com/informagi/REL/tree/master/tutorials/deploy_REL_new_Wiki/04_04_training_your_own_ED_model.md)
5. [Reproducing our results](https://github.com/informagi/REL/tree/master/tutorials/05_reproducing_our_results.md)
6. [REL as systemd service](https://github.com/informagi/REL/tree/master/tutorials/06_systemd_instructions.md)
7. [Notes on using custom models](https://github.com/informagi/REL/tree/master/tutorials/07_custom_models.md)

# Cite
If you are using REL, please cite the following paper:

```bibtex
@inproceedings{vanHulst:2020:REL,
 author =    {van Hulst, Johannes M. and Hasibi, Faegheh and Dercksen, Koen and Balog, Krisztian and de Vries, Arjen P.},
 title =     {REL: An Entity Linker Standing on the Shoulders of Giants},
 booktitle = {Proceedings of the 43rd International ACM SIGIR Conference on Research and Development in Information Retrieval},
 series =    {SIGIR '20},
 year =      {2020},
 publisher = {ACM}
}
```

# Contact
Please email your questions or comments to [Mick van Hulst](mailto:mick.vanhulst@gmail.com)

# Acknowledgements
Our thanks go out to the authors that open-sourced their code, enabling us to create this package that can hopefully be of service to many.
