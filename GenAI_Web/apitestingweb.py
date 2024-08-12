from flask import Flask, request, jsonify, render_template
from time import time
import torch
import transformers
from transformers import AutoTokenizer
import pandas as pd
from sentence_transformers import SentenceTransformer
import chromadb
from langchain.llms import HuggingFacePipeline
from langchain.chains import RetrievalQA
from langchain.vectorstores import Chroma
from transformers import AutoConfig
from langchain.embeddings import HuggingFaceEmbeddings
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# # Initialize models and components
# model_id = 'kalisai/Nusantara-7b-Indo-Chat'

# # Set the random seed for reproducibility
# torch.manual_seed(42)
# torch.cuda.manual_seed_all(42)
# torch.backends.cudnn.deterministic = True
# torch.backends.cudnn.benchmark = False

# # Set the device
# device = f'cuda:{torch.cuda.current_device()}' if torch.cuda.is_available() else 'cpu'

# bnb_config = transformers.BitsAndBytesConfig(
#     load_in_4bit=True,
#     bnb_4bit_quant_type='nf4',
#     bnb_4bit_use_double_quant=True,
#     bnb_4bit_compute_dtype=torch.bfloat16
# )

# model_config = transformers.AutoConfig.from_pretrained(
#     model_id,
#     trust_remote_code=True,
#     max_new_tokens=1024,
# )

# model = transformers.AutoModelForCausalLM.from_pretrained(
#     model_id,
#     trust_remote_code=True,
#     quantization_config=bnb_config,
#     config=model_config
# )

# tokenizer = AutoTokenizer.from_pretrained(model_id)

# query_pipeline = transformers.pipeline(
#     "text-generation",
#     model=model,
#     tokenizer=tokenizer,
#     torch_dtype=torch.float16,
#     device_map="auto",
#     max_new_tokens=2048
# )

# df = pd.read_excel("./cleaned_output.xlsx")
# df['cleaned_text'].fillna('', inplace=True)

# emb_model = SentenceTransformer('LazarusNLP/all-indo-e5-small-v4')

# def embed_text(text):
#     return emb_model.encode(text)

# df['embedded_context'] = df['cleaned_text'].apply(embed_text)

# persistent_clients = chromadb.PersistentClient()
# collections = persistent_clients.get_or_create_collection("private-llms")

# for index, row in df.iterrows():
#     collections.add(
#         documents=row['cleaned_text'],
#         embeddings=row['embedded_context'].tolist(),
#         metadatas=[{'title': row['judul_artikel'], 'html_str': row['konten_artikel']}],
#         ids=[str(index)]
#     )

# embeddings = HuggingFaceEmbeddings(model_name='LazarusNLP/all-indo-e5-small-v4')

# langchain_chroma = Chroma(
#     client=persistent_clients,
#     collection_name="private-llms",
#     embedding_function=embeddings,
# )

# llm = HuggingFacePipeline(pipeline=query_pipeline)

# retriever = langchain_chroma.as_retriever()

# qa = RetrievalQA.from_chain_type(
#     llm=llm,
#     chain_type="stuff",
#     retriever=retriever,
#     verbose=False
# )

def test_rag(qa, query):
    time_start = time()
    response = qa.run(query)
    start_index = response.find("Helpful Answer:")
    if start_index != -1:
        response = response[start_index:]
    time_end = time()
    total_time = f"{round(time_end - time_start, 3)} sec."
    full_response = f"Question: {query}\nAnswer: {response}\nTotal time: {total_time}"
    print(f"Debug info - Query: {query}")
    print(f"Debug info - Response: {response}")
    print(f"Debug info - Total time: {total_time}")
    torch.cuda.empty_cache()
    return response

@app.route('/')
def index():
    # Serve the HTML file
    return render_template('KP_WebGenAI2.html')

@app.route('/api/chatbot', methods=['POST'])
def chatbot_api():
    try:
        data = request.json
        print("Received data:", data)  # Log received data
        query = data.get('query')
        if query:
            # response = test_rag(qa, query)
            response = "test response berhasil"
            return jsonify({'response': response})
        else:
            return jsonify({'response': 'Invalid input'}), 400
    except Exception as e:
        print("Error:", e)  # Log any exception that occurs
        return jsonify({'response': 'Internal server error'}), 500

if __name__ == '__main__':
    app.run(debug=True)
