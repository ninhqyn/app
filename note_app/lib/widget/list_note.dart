import 'package:flutter/material.dart';
import 'package:note_app/model/note.dart';
class ListNote extends StatefulWidget{
  List<Note> items;
  Function deleteData;
  Function editData;

  ListNote(this.items,this.deleteData,this.editData);

  @override
  State<StatefulWidget> createState()=>_ListNoteState();
}
class _ListNoteState extends State<ListNote>{
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context,index){
        return InkWell(
          onLongPress: (){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: const Text('Confirm'),
                    content: const Text('Are you sure ?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context, 'Cancel');
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.deleteData(widget.items[index].id);
                          Navigator.pop(context, 'OK');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                });
            print(widget.items[index].name);
          },
          child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:(index % 2 ==0) ?  Colors.blue : Colors.pink,
              ),
              margin: const EdgeInsets.only(top: 10,left: 10,right: 10),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(  // Sử dụng Expanded để Text có thể chiếm toàn bộ không gian còn lại
                          child: Text(
                            widget.items[index].name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            softWrap: true,
                            maxLines: 2,  // Giới hạn văn bản chỉ hiển thị tối đa 2 dòng
                            overflow: TextOverflow.ellipsis, // Không cắt văn bản
                          ),
                        ),
                        const SizedBox(width: 10,),
                        InkWell(
                            onTap: (){
                              _controller.text = widget.items[index].name;
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context){
                                    return Padding(
                                      padding: MediaQuery.of(context).viewInsets,
                                      child: SingleChildScrollView(
                                        child: SizedBox(
                                          height: 200,
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller: _controller,
                                                  onChanged: (text){
                                                  },
                                                  decoration: const InputDecoration(
                                                      border:  OutlineInputBorder(),
                                                      labelText: "Your Note"
                                                  ),
                                                ),
                                                const SizedBox(height: 20,),
                                                SizedBox(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.blue,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10)
                                                          )
                                                      ),
                                                      onPressed: (){
                                                        Note note = widget.items[index];
                                                        note.name = _controller.text;
                                                        widget.editData(note);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("Edit note",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: const Icon(Icons.edit)),
                      ],
                    ),
                    widget.items[index].image.isNotEmpty
                        ? FittedBox(
                        fit: BoxFit.fill,
                        child: Image.memory(widget.items[index].image,width: 100,height: 100,))
                        : const SizedBox(),

                  ],
                ),
              )),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

}