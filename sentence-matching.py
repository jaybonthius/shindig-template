import nltk
from nltk.tokenize import sent_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# Download required NLTK data
nltk.download("punkt")
nltk.download("punkt_tab")
nltk.download("stopwords")
nltk.download("wordnet")


def preprocess_text(text):
    # Tokenize the text into sentences
    sentences = sent_tokenize(text)

    # Initialize lemmatizer and stopwords
    lemmatizer = WordNetLemmatizer()
    stop_words = set(stopwords.words("english"))

    # Preprocess each sentence
    processed_sentences = []
    for sentence in sentences:
        # Tokenize words, convert to lowercase, remove stopwords and punctuation
        words = [
            lemmatizer.lemmatize(word.lower())
            for word in nltk.word_tokenize(sentence)
            if word.lower() not in stop_words and word.isalnum()
        ]
        processed_sentences.append(" ".join(words))

    return processed_sentences, sentences


def find_closest_sentence(target_sentence, text):
    # Preprocess the text and the target sentence
    processed_sentences, original_sentences = preprocess_text(text)
    processed_target, _ = preprocess_text(target_sentence)

    # Create TF-IDF vectorizer
    vectorizer = TfidfVectorizer()

    # Fit and transform the sentences (including the target sentence)
    all_sentences = processed_sentences + processed_target
    tfidf_matrix = vectorizer.fit_transform(all_sentences)

    # Calculate cosine similarity between target sentence and all other sentences
    target_vector = tfidf_matrix[-1]
    similarities = cosine_similarity(target_vector, tfidf_matrix[:-1])[0]

    # Find the index of the most similar sentence
    most_similar_index = similarities.argmax()

    return original_sentences[most_similar_index], similarities[most_similar_index]


# Example usage
text = """
Let's plan a trip to the seaside this weekend. The mathematics weather forecast looks great, 
and we could all use some sun and relaxation. We can build sandcastles, swim in 
the ocean, and enjoy a picnic on the shore. The math makes sense, but you need to read the book closely. It's been a while since we've had a 
day out together, so this could be a perfect opportunity to unwind and have fun.
"""

# Simulate storing the fingerprint in the database
target_sentence = "The mathematics here are perfectly sound, but it's important that the reader makes strides to understand the minute details."

closest_match, similarity_score = find_closest_sentence(target_sentence, text)
print(f"Original: '{target_sentence}'")
print(f"Closest match: '{closest_match}'")
print(f"Similarity score: {similarity_score:.2f}")
